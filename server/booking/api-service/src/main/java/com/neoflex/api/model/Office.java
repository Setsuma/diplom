package com.neoflex.api.model;

import jakarta.persistence.*;
import lombok.Data;
import java.util.List;
import java.util.UUID;

@Data
@Entity
@Table(name = "offices")
public class Office {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private UUID id;
    
    @Column(nullable = false)
    private String name;
    
    @Column(nullable = false)
    private String address;
    
    @Column(name = "floor_plan_url", nullable = false)
    private String floorPlanUrl;
    
    @Column(name = "floor_plan_width")
    private Integer floorPlanWidth;
    
    @Column(name = "floor_plan_height")
    private Integer floorPlanHeight;
    
    @OneToMany(mappedBy = "office", cascade = CascadeType.ALL)
    private List<Marker> markers;
} 