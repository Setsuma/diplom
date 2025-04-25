package com.neoflex.api.service;

import com.neoflex.api.dto.MarkerRequest;
import com.neoflex.api.dto.MarkerResponse;
import com.neoflex.api.model.Marker;
import com.neoflex.api.model.Office;
import com.neoflex.api.repository.MarkerRepository;
import com.neoflex.api.repository.OfficeRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class MarkerService {

    private final MarkerRepository markerRepository;
    private final OfficeRepository officeRepository;

    @Transactional
    public MarkerResponse createMarker(MarkerRequest request) {
        Office office = officeRepository.findById(request.getOfficeId())
                .orElseThrow(() -> new RuntimeException("Office not found"));

        Marker marker = new Marker();
        marker.setTitle(request.getTitle());
        marker.setDescription(request.getDescription());
        marker.setX(request.getX());
        marker.setY(request.getY());
        marker.setType(request.getType());
        marker.setOffice(office);

        return convertToResponse(markerRepository.save(marker));
    }

    @Transactional(readOnly = true)
    public List<MarkerResponse> getOfficeMarkers(UUID officeId) {
        return markerRepository.findByOfficeId(officeId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    private MarkerResponse convertToResponse(Marker marker) {
        MarkerResponse response = new MarkerResponse();
        response.setId(marker.getId());
        response.setOfficeId(marker.getOffice().getId());
        response.setTitle(marker.getTitle());
        response.setDescription(marker.getDescription());
        response.setX(marker.getX());
        response.setY(marker.getY());
        response.setType(marker.getType());
        response.setBooked(marker.getCurrentBooking() != null);
        return response;
    }
} 