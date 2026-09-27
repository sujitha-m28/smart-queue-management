package com.example.queuemanagement.controller;

import com.example.queuemanagement.dto.PredictionInputDTO;
import com.example.queuemanagement.service.AIService;
import org.springframework.web.bind.annotation.*;
import com.example.queuemanagement.dto.PredictionResponseDTO;
@RestController
@RequestMapping("/ai")
public class AIController {

    private final AIService aiService;

    public AIController(AIService aiService) {
        this.aiService = aiService;
    }
    @PostMapping("/predict")
    public PredictionResponseDTO predict(
            @RequestBody PredictionInputDTO input) {

        return aiService.predictServiceTime(
                input.getQueuePosition(),
                input.getWaitingTime(),
                input.getHourOfDay()
        );
    }

}