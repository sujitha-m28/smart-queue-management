package com.example.queuemanagement.dto;

public class PredictionResponseDTO {

    private double predictedServiceTime;

    public PredictionResponseDTO() {
    }

    public double getPredictedServiceTime() {
        return predictedServiceTime;
    }

    public void setPredictedServiceTime(double predictedServiceTime) {
        this.predictedServiceTime = predictedServiceTime;
    }
}