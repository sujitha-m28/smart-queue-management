package com.example.queuemanagement.service;

import org.springframework.stereotype.Service;

@Service
public class NotificationService {

    private final SmsService smsService;

    public NotificationService(SmsService smsService) {
        this.smsService = smsService;
    }

    public void sendQueueNotification(
            Long queueId,
            String phone,
            String tokenNumber,
            int position) {

        if (position == 3 && notifiedQueueIds.add(queueId)) {

            String message =
                    "Your token " + tokenNumber +
                            " is now 3rd in the queue. " +
                            "Please get ready for your trial room.";

            smsService.sendSms(phone, message);
        }
    }

    private final java.util.Set<Long> notifiedQueueIds =
            new java.util.HashSet<>();
}