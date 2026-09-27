package com.example.queuemanagement.controller;

import com.example.queuemanagement.entity.Queue;
import com.example.queuemanagement.service.QueueService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.example.queuemanagement.dto.QueueTrainingDataDTO;
import java.util.List;
import com.example.queuemanagement.dto.PredictionInputDTO;
import com.example.queuemanagement.dto.PredictionResponseDTO;
import com.example.queuemanagement.dto.AIPredictionDTO;
@RestController
@RequestMapping("/queue")
public class QueueController {

    private final QueueService queueService;

    public QueueController(QueueService queueService) {
        this.queueService = queueService;
    }

    @PostMapping("/take-token/{customerId}")
    public ResponseEntity<Queue> takeToken(@PathVariable Long customerId) {

        Queue queue = queueService.takeToken(customerId);

        return ResponseEntity.status(201).body(queue);
    }

    @GetMapping
    public ResponseEntity<List<Queue>> getQueue() {
        return ResponseEntity.ok(queueService.getQueue());
    }

    @PostMapping("/next")
    public ResponseEntity<Queue> callNextCustomer() {

        Queue queue = queueService.callNextCustomer();

        return ResponseEntity.ok(queue);
    }

    @PutMapping("/{queueId}/complete")
    public ResponseEntity<Queue> completeCustomer(
            @PathVariable Long queueId) {

        Queue queue = queueService.completeCustomer(queueId);

        return ResponseEntity.ok(queue);
    }
    @DeleteMapping("/{queueId}/cancel")
    public ResponseEntity<Void> cancelToken(
            @PathVariable Long queueId) {

        queueService.cancelToken(queueId);

        return ResponseEntity.noContent().build();
    }
    @GetMapping("/{queueId}/service-duration")
    public ResponseEntity<Long> getServiceDuration(
            @PathVariable Long queueId) {

        long duration = queueService.calculateServiceDuration(queueId);

        return ResponseEntity.ok(duration);
    }
    @GetMapping("/average-service-time")
    public ResponseEntity<Long> getAverageServiceTime() {

        long averageTime = queueService.calculateAverageServiceTime();

        return ResponseEntity.ok(averageTime);
    }
    @GetMapping("/{queueId}/waiting-duration")
    public ResponseEntity<Long> getWaitingDuration(
            @PathVariable Long queueId) {

        long duration = queueService.calculateWaitingDuration(queueId);

        return ResponseEntity.ok(duration);
    }
    @GetMapping("/completed")
    public ResponseEntity<List<Queue>> getCompletedQueues() {

        List<Queue> completedQueues =
                queueService.getCompletedQueues();

        return ResponseEntity.ok(completedQueues);
    }
    @GetMapping("/training-data")
    public ResponseEntity<List<QueueTrainingDataDTO>> getQueueTrainingData() {

        List<QueueTrainingDataDTO> data =
                queueService.getQueueTrainingData();

        return ResponseEntity.ok(data);
    }
    @PostMapping("/predict")
    public ResponseEntity<PredictionResponseDTO> predictServiceTime(
            @RequestBody PredictionInputDTO input) {

        PredictionResponseDTO prediction =
                queueService.predictServiceTime(
                        input.getQueuePosition(),
                        input.getWaitingTime(),
                        input.getHourOfDay()
                );

        return ResponseEntity.ok(prediction);
    }
    @GetMapping("/{queueId}/position")
    public ResponseEntity<Integer> getQueuePosition(
            @PathVariable Long queueId) {

        int position = queueService.getQueuePosition(queueId);

        return ResponseEntity.ok(position);
    }
    @GetMapping("/{queueId}/estimated-waiting-time")
    public ResponseEntity<Long> getEstimatedWaitingTime(
            @PathVariable Long queueId) {

        long waitingTime =
                queueService.calculateEstimatedWaitingTime(queueId);

        return ResponseEntity.ok(waitingTime);
    }
    @PostMapping("/{queueId}/ai-prediction")
    public ResponseEntity<PredictionResponseDTO> predictForQueue(
            @PathVariable Long queueId) {

        PredictionResponseDTO prediction =
                queueService.predictForQueue(queueId);

        return ResponseEntity.ok(prediction);
    }
    @GetMapping("/{queueId}/ai-service-time")
    public ResponseEntity<Long> getAIPredictedServiceTime(
            @PathVariable Long queueId) {

        long predictedTime =
                queueService.getAIPredictedServiceTime(queueId);

        return ResponseEntity.ok(predictedTime);
    }
    @GetMapping("/{queueId}/ai-waiting-time")
    public ResponseEntity<Double> getAIPredictedWaitingTime(
            @PathVariable Long queueId) {

        double waitingTime =
                queueService.calculateAIPredictedWaitingTime(queueId);

        return ResponseEntity.ok(waitingTime);
    }
    @GetMapping("/ai-predictions")
    public ResponseEntity<List<AIPredictionDTO>> predictForAllActiveQueues() {

        List<AIPredictionDTO> predictions =
                queueService.predictForAllActiveQueues();

        return ResponseEntity.ok(predictions);
    }
}