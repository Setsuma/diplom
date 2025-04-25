package com.neoflex.api.service;

import com.neoflex.api.dto.BookingRequest;
import com.neoflex.api.dto.BookingResponse;
import com.neoflex.api.model.Booking;
import com.neoflex.api.model.BookingStatus;
import com.neoflex.api.exception.BookingNotFoundException;
import com.neoflex.api.exception.UnauthorizedAccessException;
import com.neoflex.api.repository.BookingRepository;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class BookingService {
    private final BookingRepository bookingRepository;

    public BookingService(BookingRepository bookingRepository) {
        this.bookingRepository = bookingRepository;
    }

    @Transactional
    public BookingResponse createBooking(BookingRequest request) {
        UUID userId = UUID.fromString(getCurrentUserId());
        
        if (request.getStartTime().isAfter(request.getEndTime())) {
            throw new IllegalArgumentException("Start time must be before end time");
        }
        
        Booking booking = new Booking();
        booking.setUserId(userId);
        booking.setTitle(request.getTitle());
        booking.setDescription(request.getDescription());
        booking.setStartTime(request.getStartTime());
        booking.setEndTime(request.getEndTime());
        booking.setStatus(BookingStatus.PENDING);
        
        return convertToResponse(bookingRepository.save(booking));
    }

    @Transactional(readOnly = true)
    public List<BookingResponse> getUserBookings() {
        UUID userId = UUID.fromString(getCurrentUserId());
        return bookingRepository.findByUserIdOrderByStartTimeDesc(userId)
                .stream()
                .map(this::convertToResponse)
                .collect(Collectors.toList());
    }

    @Transactional
    public BookingResponse updateBookingStatus(UUID bookingId, BookingStatus status) {
        UUID userId = UUID.fromString(getCurrentUserId());
        Booking booking = bookingRepository.findById(bookingId)
                .orElseThrow(() -> new BookingNotFoundException("Booking not found with id: " + bookingId));
        
        if (!booking.getUserId().equals(userId)) {
            throw new UnauthorizedAccessException("You don't have permission to update this booking");
        }
        
        booking.setStatus(status);
        return convertToResponse(bookingRepository.save(booking));
    }

    private String getCurrentUserId() {
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        if (authentication == null || !authentication.isAuthenticated()) {
            throw new UnauthorizedAccessException("User not authenticated");
        }
        return authentication.getName();
    }

    private BookingResponse convertToResponse(Booking booking) {
        if (booking == null) {
            return null;
        }
        
        BookingResponse response = new BookingResponse();
        response.setId(booking.getId());
        response.setTitle(booking.getTitle());
        response.setDescription(booking.getDescription());
        response.setStartTime(booking.getStartTime());
        response.setEndTime(booking.getEndTime());
        response.setStatus(booking.getStatus());
        response.setUserId(booking.getUserId());
        return response;
    }
} 