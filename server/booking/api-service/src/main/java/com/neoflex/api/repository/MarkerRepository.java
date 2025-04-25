package com.neoflex.api.repository;

import com.neoflex.api.model.Marker;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface MarkerRepository extends JpaRepository<Marker, UUID> {
    List<Marker> findByOfficeId(UUID officeId);
} 