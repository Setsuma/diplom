package com.neoflex.api.controller;

import com.neoflex.api.dto.MarkerRequest;
import com.neoflex.api.dto.MarkerResponse;
import com.neoflex.api.service.MarkerService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/markers")
@RequiredArgsConstructor
public class MarkerController {

    private final MarkerService markerService;

    @PostMapping
    public ResponseEntity<MarkerResponse> createMarker(@RequestBody MarkerRequest request) {
        return ResponseEntity.ok(markerService.createMarker(request));
    }

    @GetMapping
    public ResponseEntity<List<MarkerResponse>> getOfficeMarkers(@RequestParam UUID officeId) {
        return ResponseEntity.ok(markerService.getOfficeMarkers(officeId));
    }
} 