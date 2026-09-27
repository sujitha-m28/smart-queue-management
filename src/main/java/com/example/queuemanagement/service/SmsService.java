package com.example.queuemanagement.service;

import com.twilio.Twilio;
import com.twilio.rest.api.v2010.account.Message;
import com.twilio.type.PhoneNumber;
import org.springframework.stereotype.Service;

@Service
public class SmsService {

    private final String accountSid =
            System.getenv("TWILIO_ACCOUNT_SID");

    private final String authToken =
            System.getenv("TWILIO_AUTH_TOKEN");

    private final String fromNumber =
            System.getenv("TWILIO_PHONE_NUMBER");

    public void sendSms(String phone, String message) {

        System.out.println("=================================");
        System.out.println("📱 SMS SENT!");
        System.out.println("To: " + phone);
        System.out.println("Message: " + message);
        System.out.println("=================================");
    }
}