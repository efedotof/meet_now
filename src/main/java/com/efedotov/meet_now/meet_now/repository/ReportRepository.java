package com.efedotov.meet_now.meet_now.repository;

import java.util.*;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import com.efedotov.meet_now.meet_now.model.Report;

@Repository
public interface ReportRepository extends JpaRepository<Report, UUID> {
    List<Report> findByReporter_Id(UUID reporterId);

    List<Report> findByReported_Id(UUID reportedId);
}
