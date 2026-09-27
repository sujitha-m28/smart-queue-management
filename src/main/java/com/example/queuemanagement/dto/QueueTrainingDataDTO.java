package com.example.queuemanagement.dto;

public class QueueTrainingDataDTO {

    private Long queueId;
    private Long customerId;
    private String tokenNumber;

    private long waitingDuration;
    private long serviceDuration;
    private int queuePosition;
    private int hourOfDay;
    public QueueTrainingDataDTO() {
    }

    public QueueTrainingDataDTO(
            Long queueId,
            Long customerId,
            String tokenNumber,
            int queuePosition,
            long waitingDuration,
            long serviceDuration,
            int hourOfDay) {

        this.queueId = queueId;
        this.customerId = customerId;
        this.tokenNumber = tokenNumber;
        this.waitingDuration = waitingDuration;

        this.serviceDuration = serviceDuration;
        this.queuePosition = queuePosition;
        this.hourOfDay = hourOfDay;
    }

    public Long getQueueId() {
        return queueId;
    }

    public Long getCustomerId() {
        return customerId;
    }

    public String getTokenNumber() {
        return tokenNumber;
    }

    public long getWaitingDuration() {
        return waitingDuration;
    }

    public long getServiceDuration() {
        return serviceDuration;
    }

    public int getQueuePosition() {
        return queuePosition;
    }

    public int getHourOfDay() {
        return hourOfDay;
    }
}