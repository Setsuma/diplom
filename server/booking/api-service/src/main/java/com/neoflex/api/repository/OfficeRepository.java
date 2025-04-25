package com.neoflex.api.repository;

import com.neoflex.api.model.Office;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.UUID;

public interface OfficeRepository extends JpaRepository<Office, UUID> {
} 