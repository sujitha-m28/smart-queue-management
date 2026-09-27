package com.example.queuemanagement.entity;
import jakarta.persistence.*;
import java.time.LocalDateTime;
@Entity
public class Queue {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    private String tokenNumber;
    @ManyToOne
    private Customer customer;
    @Enumerated(EnumType.STRING)
    private QueueStatus status;
    private LocalDateTime serviceStartTime;

    private LocalDateTime serviceEndTime;
    private LocalDateTime createdAt;
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTokenNumber() {
        return tokenNumber;
    }

    public void setTokenNumber(String tokenNumber) {
        this.tokenNumber = tokenNumber;
    }

    public Customer getCustomer() {
        return customer;
    }

    public void setCustomer(Customer customer) {
        this.customer = customer;
    }

    public QueueStatus getStatus() {
        return status;
    }

    public void setStatus(QueueStatus status) {
        this.status = status;
    }
    public Queue() {
    }
    public LocalDateTime getServiceStartTime() {
        return serviceStartTime;
    }

    public void setServiceStartTime(LocalDateTime serviceStartTime) {
        this.serviceStartTime = serviceStartTime;
    }

    public LocalDateTime getServiceEndTime() {
        return serviceEndTime;
    }

    public void setServiceEndTime(LocalDateTime serviceEndTime) {
        this.serviceEndTime = serviceEndTime;
    }
    public LocalDateTime getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(LocalDateTime createdAt) {
        this.createdAt = createdAt;
    }
}
