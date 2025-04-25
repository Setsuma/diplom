package com.neoflex.api.dto;

import com.neoflex.api.model.MarkerType;
import lombok.Data;
import java.util.UUID;

@Data
public class MarkerRequest {
    private UUID officeId;
    private String title;
    private String description;
    private Double x;
    private Double y;
    private MarkerType type;
} 