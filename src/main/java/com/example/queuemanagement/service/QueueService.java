package com.example.queuemanagement.service;
import com.example.queuemanagement.dto.AIPredictionDTO;
import com.example.queuemanagement.entity.Customer;
import com.example.queuemanagement.entity.Queue;
import com.example.queuemanagement.entity.QueueStatus;
import com.example.queuemanagement.repository.CustomerRepository;
import com.example.queuemanagement.repository.QueueRepository;
import com.example.queuemanagement.dto.PredictionResponseDTO;
import org.springframework.stereotype.Service;
import java.util.List;

import java.time.LocalDateTime;
import com.example.queuemanagement.dto.QueueTrainingDataDTO;
@Service
public class QueueService {

    private final QueueRepository queueRepository;
    private final CustomerRepository customerRepository;
    private final AIService aiService;
    private final NotificationService notificationService;
    private final SmsService smsService;
    public QueueService(
            QueueRepository queueRepository,
            CustomerRepository customerRepository,
            AIService aiService,
            NotificationService notificationService,
            SmsService smsService) {

        this.queueRepository = queueRepository;
        this.customerRepository = customerRepository;
        this.aiService = aiService;
        this.notificationService = notificationService;
        this.smsService = smsService;
    }

    public Queue takeToken(Long customerId) {

        Customer customer = customerRepository.findById(customerId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Customer with id " + customerId + " not found"
                        ));

        Queue queue = new Queue();

        queue.setCustomer(customer);
        queue.setCreatedAt(LocalDateTime.now());
        long tokenNumber = queueRepository.count() + 1;
        queue.setTokenNumber("MS" + tokenNumber);

        queue.setStatus(QueueStatus.WAITING);

        Queue savedQueue = queueRepository.save(queue);

        checkPositionThree();

        return savedQueue;
    }
    public List<Queue> getQueue() {
        return queueRepository.findByStatusInOrderByCreatedAtAsc(
                List.of(
                        QueueStatus.WAITING,
                        QueueStatus.SERVING
                )
        );
    }
    public Queue callNextCustomer() {

        boolean customerAlreadyServing =
                queueRepository.findByStatusInOrderByCreatedAtAsc(
                        List.of(QueueStatus.SERVING)
                ).size() > 0;

        if (customerAlreadyServing) {
            throw new RuntimeException("A customer is already being served");
        }

        Queue queue = queueRepository
                .findFirstByStatusOrderByIdAsc(QueueStatus.WAITING)
                .orElseThrow(() ->
                        new RuntimeException("No customers waiting in the queue"));

        queue.setStatus(QueueStatus.SERVING);
        queue.setServiceStartTime(LocalDateTime.now());

        return queueRepository.save(queue);
    }
    public Queue completeCustomer(Long queueId) {

        Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Queue with id " + queueId + " not found"
                        ));

        queue.setStatus(QueueStatus.COMPLETED);
        queue.setServiceEndTime(LocalDateTime.now());

        return queueRepository.save(queue);
    }
    public long calculateServiceDuration(Long queueId) {

        Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Queue with id " + queueId + " not found"
                        ));

        if (queue.getServiceStartTime() == null ||
                queue.getServiceEndTime() == null) {

            throw new RuntimeException(
                    "Service has not been completed yet"
            );
        }

        return java.time.Duration.between(
                queue.getServiceStartTime(),
                queue.getServiceEndTime()
        ).getSeconds();
    }
    public long calculateAverageServiceTime() {

        List<Queue> completedQueues =
                queueRepository.findCompletedQueuesWithServiceTime()
                        .stream()
                        .filter(queue ->
                                java.time.Duration.between(
                                        queue.getServiceStartTime(),
                                        queue.getServiceEndTime()
                                ).getSeconds() <= 3600
                        )
                        .toList();

        if (completedQueues.isEmpty()) {
            return 0;
        }

        long totalSeconds = 0;

        for (Queue queue : completedQueues) {

            long duration = java.time.Duration.between(
                    queue.getServiceStartTime(),
                    queue.getServiceEndTime()
            ).getSeconds();

            totalSeconds += duration;
        }

        return totalSeconds / completedQueues.size();
    }
    public long calculateWaitingDuration(Long queueId) {

        Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Queue with id " + queueId + " not found"
                        ));

        if (queue.getCreatedAt() == null ||
                queue.getServiceStartTime() == null) {

            throw new RuntimeException(
                    "Waiting period has not been completed yet"
            );
        }

        return java.time.Duration.between(
                queue.getCreatedAt(),
                queue.getServiceStartTime()
        ).getSeconds();
    }
    public List<Queue> getCompletedQueues() {

        return queueRepository.findCompletedQueuesWithServiceTime();
    }
    public List<QueueTrainingDataDTO> getQueueTrainingData() {

        List<Queue> completedQueues =
                queueRepository.findCompletedQueuesWithServiceTime()
                        .stream()
                        .filter(queue ->
                                java.time.Duration.between(
                                        queue.getServiceStartTime(),
                                        queue.getServiceEndTime()
                                ).getSeconds() <= 3600
                        )
                        .toList();
        List<Queue> allQueues =
                queueRepository.findByCreatedAtIsNotNullOrderByCreatedAtAsc();

        return completedQueues.stream()
                .filter(queue ->
                        java.time.Duration.between(
                                queue.getServiceStartTime(),
                                queue.getServiceEndTime()
                        ).getSeconds() <= 3600
                                &&
                                java.time.Duration.between(
                                        queue.getCreatedAt(),
                                        queue.getServiceStartTime()
                                ).getSeconds() <= 3600
                )
                .map(queue -> {

                    long waitingDuration =
                            java.time.Duration.between(
                                    queue.getCreatedAt(),
                                    queue.getServiceStartTime()
                            ).getSeconds();

                    long serviceDuration =
                            java.time.Duration.between(
                                    queue.getServiceStartTime(),
                                    queue.getServiceEndTime()
                            ).getSeconds();
                    int queuePosition = 0;

                    for (Queue q : allQueues) {

                        if (q.getCreatedAt().isBefore(queue.getCreatedAt())
                                || q.getCreatedAt().isEqual(queue.getCreatedAt())) {

                            queuePosition++;
                        }
                    }
                    return new QueueTrainingDataDTO(
                            queue.getId(),
                            queue.getCustomer().getId(),
                            queue.getTokenNumber(),
                            queuePosition,
                            waitingDuration,
                            serviceDuration,
                            queue.getCreatedAt().getHour()
                    );
                })
                .toList();
    }
    public PredictionResponseDTO predictServiceTime(
            int queuePosition,
            int waitingTime,
            int hourOfDay) {

        return aiService.predictServiceTime(
                queuePosition,
                waitingTime,
                hourOfDay
        );
    }
    public int getQueuePosition(Long queueId) {

        List<Queue> waitingCustomers =
                queueRepository.findByStatusInOrderByCreatedAtAsc(                        List.of(
                                QueueStatus.WAITING,
                                QueueStatus.SERVING
                        )
                );

        for (int i = 0; i < waitingCustomers.size(); i++) {

            if (waitingCustomers.get(i).getId().equals(queueId)) {

                int position = i + 1;

                System.out.println(
                        "QUEUE POSITION FOUND: " + position
                );



                return position;
            }
        }

        throw new RuntimeException(
                "Queue customer with id " + queueId + " not found"
        );
    }
    public long calculateEstimatedWaitingTime(Long queueId) {

        int position = getQueuePosition(queueId);

        long averageServiceTime = calculateAverageServiceTime();

        if (position <= 1) {
            return 0;
        }

        return (position - 1) * averageServiceTime;
    }
    public PredictionResponseDTO predictForQueue(Long queueId) {

        int position = getQueuePosition(queueId);

        long waitingTime =
                calculateEstimatedWaitingTime(queueId);

        Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Queue with id " + queueId + " not found"
                        ));

        int hourOfDay = queue.getCreatedAt().getHour();

        return aiService.predictServiceTime(
                position,
                (int) waitingTime,
                hourOfDay
        );
    }
    public long getAIPredictedServiceTime(Long queueId) {

        int position = getQueuePosition(queueId);

        long waitingTime =
                calculateEstimatedWaitingTime(queueId);

        Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Queue with id " + queueId + " not found"
                        ));

        int hourOfDay = queue.getCreatedAt().getHour();

        PredictionResponseDTO prediction =
                aiService.predictServiceTime(
                        position,
                        (int) waitingTime,
                        hourOfDay
                );

        return Math.round(
                prediction.getPredictedServiceTime()
        );
    }
    public List<AIPredictionDTO> predictForAllActiveQueues() {

        List<Queue> activeQueues =
                queueRepository.findByStatusInOrderByCreatedAtAsc(
                        List.of(
                                QueueStatus.WAITING,
                                QueueStatus.SERVING
                        )
                );

        return activeQueues.stream()
                .map(queue -> {

                    PredictionResponseDTO prediction =
                            predictForQueue(queue.getId());

                    double predictedServiceTime =
                            prediction.getPredictedServiceTime();

                    int position =
                            getQueuePosition(queue.getId());

                    double predictedWaitingTime =
                            calculateAIPredictedWaitingTime(queue.getId());
                    return new AIPredictionDTO(
                            queue.getId(),
                            predictedServiceTime,
                            predictedWaitingTime
                    );
                })
                .toList();
    }
    public void cancelToken(Long queueId) {

        Queue queue = queueRepository.findById(queueId)
                .orElseThrow(() ->
                        new RuntimeException(
                                "Queue with id " + queueId + " not found"
                        ));

        queueRepository.delete(queue);
    }
    public double getPredictedServiceTimeForQueue(Long queueId) {

        PredictionResponseDTO prediction =
                predictForQueue(queueId);

        return prediction.getPredictedServiceTime();
    }
    public double calculateAIPredictedWaitingTime(Long queueId) {

        List<Queue> activeQueues =
                queueRepository.findByStatusInOrderByCreatedAtAsc(
                        List.of(
                                QueueStatus.WAITING,
                                QueueStatus.SERVING
                        )
                );

        double totalWaitingTime = 0;

        for (Queue queue : activeQueues) {

            if (queue.getId().equals(queueId)) {
                break;
            }

            if (queue.getStatus() == QueueStatus.SERVING) {

                double predictedServiceTime =
                        getPredictedServiceTimeForQueue(queue.getId());

                long elapsedSeconds =
                        java.time.Duration.between(
                                queue.getServiceStartTime(),
                                java.time.LocalDateTime.now()
                        ).getSeconds();

                double remainingTime =
                        Math.max(
                                0,
                                predictedServiceTime - elapsedSeconds
                        );

                totalWaitingTime += remainingTime;

            } else {

                totalWaitingTime +=
                        getPredictedServiceTimeForQueue(queue.getId());
            }
        }

        return totalWaitingTime;
    }
    public void checkPositionThree() {

        List<Queue> activeQueues =
                queueRepository.findByStatusInOrderByCreatedAtAsc(
                        List.of(
                                QueueStatus.WAITING,
                                QueueStatus.SERVING
                        )
                );

        for (int i = 0; i < activeQueues.size(); i++) {

            Queue queue = activeQueues.get(i);

            int position = i + 1;

            if (position == 3) {

                String phone =
                        queue.getCustomer().getPhone();

                String message =
                        "Hello " +
                                queue.getCustomer().getName() +
                                "! You are now 3rd in the trial room queue. 💕";

                smsService.sendSms(phone, message);
            }
        }
    }

}