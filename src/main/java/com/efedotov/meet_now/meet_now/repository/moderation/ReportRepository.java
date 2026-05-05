package com.efedotov.meet_now.meet_now.repository.moderation;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.lang.NonNull;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.moderation.Report;
import com.efedotov.meet_now.meet_now.model.moderation.ReportStatus;

@Repository
public interface ReportRepository extends JpaRepository<Report, UUID> {
    List<Report> findByReporter_Id(UUID reporterId);

    List<Report> findByReported_Id(UUID reportedId);

    List<Report> findByReporter_IdOrReported_Id(UUID reporterId, UUID reportedId);

    @Override
    @NonNull
    Page<Report> findAll(@NonNull Pageable pageable);

    Page<Report> findByStatus(ReportStatus status, Pageable pageable);

    long countByStatus(ReportStatus status);

    @Modifying
    @Query("DELETE FROM Report r WHERE r.reporter.id = :reporterId OR r.reported.id = :reportedId")
    void deleteByReporterIdOrReportedId(@Param("reporterId") UUID reporterId, @Param("reportedId") UUID reportedId);

    long countByReported_IdAndStatus(UUID reportedId, ReportStatus status);
}