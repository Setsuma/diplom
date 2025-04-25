package com.neoflex.api.repository;

import com.neoflex.api.model.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface BookingRepository extends JpaRepository<Booking, UUID> {
    List<Booking> findByUserIdOrderByStartTimeDesc(UUID userId);
} 