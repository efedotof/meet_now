package com.efedotov.meet_now.meet_now.model.user;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Entity
@Table(name = "free_search_usage")
@Data
public class FreeSearchUsage {
    @Id
    @Column(name = "user_id")
    private UUID userId;

    @Column(name = "used_at", nullable = false)
    private LocalDateTime usedAt = LocalDateTime.now();

    @Column(name = "used_date", nullable = false)
    private LocalDate usedDate = LocalDate.now();
}