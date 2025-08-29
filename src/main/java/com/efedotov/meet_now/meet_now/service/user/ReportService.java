package com.efedotov.meet_now.meet_now.service.user;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.stereotype.Service;

import com.efedotov.meet_now.meet_now.dto.ReportDto;
import com.efedotov.meet_now.meet_now.model.Report;
import com.efedotov.meet_now.meet_now.model.ReportStatus;
import com.efedotov.meet_now.meet_now.model.User;
import com.efedotov.meet_now.meet_now.repository.ReportRepository;
import com.efedotov.meet_now.meet_now.repository.UserRepository;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ReportService {

    private final ReportRepository reportRepository;
    private final UserRepository userRepository;

    public List<ReportDto> getUserReports(UUID userId) {
        List<Report> reports = reportRepository.findByReporter_IdOrReported_Id(userId, userId);
        return reports.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }

    public ReportDto createReport(UUID reporterId, UUID reportedId, String reason) {
        User reporter = userRepository.findById(reporterId)
                .orElseThrow(() -> new RuntimeException("Reporter not found"));
        User reported = userRepository.findById(reportedId)
                .orElseThrow(() -> new RuntimeException("Reported user not found"));

        Report report = new Report();
        report.setReporter(reporter);
        report.setReported(reported);
        report.setReason(reason);
        report.setStatus(ReportStatus.SENT);

        Report savedReport = reportRepository.save(report);
        return convertToDto(savedReport);
    }

    public void withdrawReport(UUID reportId, UUID userId) {
        Report report = reportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));

        if (!report.getReporter().getId().equals(userId)) {
            throw new RuntimeException("User is not the reporter of this report");
        }

        reportRepository.delete(report);
    }

    private ReportDto convertToDto(Report report) {
        ReportDto dto = new ReportDto();
        dto.setId(report.getId());
        dto.setReporterId(report.getReporter().getId());
        dto.setReportedId(report.getReported().getId());
        dto.setReason(report.getReason());
        dto.setStatus(report.getStatus());
        dto.setCreatedAt(report.getCreatedAt());
        return dto;
    }
}