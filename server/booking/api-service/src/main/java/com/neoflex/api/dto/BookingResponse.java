package com.neoflex.api.dto;

import com.neoflex.api.model.BookingStatus;
import lombok.Data;
import java.time.LocalDateTime;
import java.util.UUID;

@Data
public class BookingResponse {
    private UUID id;
    private String title;
    private String description;
    private LocalDateTime startTime;
    private LocalDateTime endTime;
    private BookingStatus status;
    private UUID userId;
} 