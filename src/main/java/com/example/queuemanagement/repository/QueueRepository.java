package com.example.queuemanagement.repository;

import java.util.List;
import com.example.queuemanagement.entity.Queue;
import com.example.queuemanagement.entity.QueueStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.Optional;

public interface QueueRepository extends JpaRepository<Queue, Long> {

    Optional<Queue> findFirstByStatusOrderByIdAsc(QueueStatus status);

    @Query("""
        SELECT q
        FROM Queue q
        WHERE q.status = com.example.queuemanagement.entity.QueueStatus.COMPLETED
          AND q.createdAt IS NOT NULL
          AND q.serviceStartTime IS NOT NULL
          AND q.serviceEndTime IS NOT NULL
    """)
    List<Queue> findCompletedQueuesWithServiceTime();
    List<Queue> findByCreatedAtIsNotNullOrderByCreatedAtAsc();
    List<Queue> findByStatusInOrderByCreatedAtAsc(List<QueueStatus> statuses);}