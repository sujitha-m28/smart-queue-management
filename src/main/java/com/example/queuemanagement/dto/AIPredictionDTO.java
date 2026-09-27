package com.example.queuemanagement.dto;

public class AIPredictionDTO {
    private Long queueId;
    private double predictedServiceTime;
    private double predictedWaitingTime;

    public AIPredictionDTO() {
    }

    public AIPredictionDTO(
            Long queueId,
            double predictedServiceTime,
            double predictedWaitingTime) {

        this.queueId = queueId;
        this.predictedServiceTime = predictedServiceTime;
        this.predictedWaitingTime = predictedWaitingTime;
    }

    public Long getQueueId() {
        return queueId;
    }

    public void setQueueId(Long queueId) {
        this.queueId = queueId;
    }

    public double getPredictedServiceTime() {
        return predictedServiceTime;
    }

    public void setPredictedServiceTime(double predictedServiceTime) {
        this.predictedServiceTime = predictedServiceTime;
    }

    public double getPredictedWaitingTime() {
        return predictedWaitingTime;
    }

    public void setPredictedWaitingTime(double predictedWaitingTime) {
        this.predictedWaitingTime = predictedWaitingTime;
    }
}