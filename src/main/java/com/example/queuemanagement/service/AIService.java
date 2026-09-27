package com.example.queuemanagement.service;

import org.springframework.stereotype.Service;
import org.springframework.web.client.RestClient;
import com.example.queuemanagement.dto.PredictionResponseDTO;
import org.springframework.http.MediaType;
@Service
public class AIService {

    private final RestClient restClient;

    public AIService() {
        this.restClient = RestClient
                .builder()
                .baseUrl("http://localhost:5000")
                .build();
    }

    public PredictionResponseDTO predictServiceTime(
            int queuePosition,
            int waitingTime,
            int hourOfDay) {

        PredictionResponseDTO response = restClient.post()
                .uri("/predict")
                .contentType(MediaType.APPLICATION_JSON)
                .body("""
    {
        "queuePosition": %d,
        "waitingTime": %d,
        "hourOfDay": %d
    }
    """.formatted(queuePosition, waitingTime, hourOfDay))
                .retrieve()
                .body(PredictionResponseDTO.class);

        return response;
    }
}