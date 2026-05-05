package com.efedotov.meet_now.meet_now.service.moderation;

import com.efedotov.meet_now.meet_now.dto.response.moderation.ReportDto;
import com.efedotov.meet_now.meet_now.dto.response.moderation.ReportStatisticsDto;
import com.efedotov.meet_now.meet_now.model.moderation.Report;
import com.efedotov.meet_now.meet_now.model.moderation.ReportStatus;
import com.efedotov.meet_now.meet_now.model.user.User;
import com.efedotov.meet_now.meet_now.repository.moderation.ReportRepository;
import com.efedotov.meet_now.meet_now.repository.user.UserRepository;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.auth.SessionService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Slf4j
public class ReportService {

    private final ReportRepository reportRepository;
    private final UserRepository userRepository;
    private final SessionService sessionService;

    private static final int BLOCK_THRESHOLD = 15;

    @AdminOnly
    public Page<ReportDto> getAllReports(Pageable pageable) {
        return reportRepository.findAll(pageable).map(this::convertToDto);
    }

    @AdminOnly
    public Page<ReportDto> getReportsByStatus(ReportStatus status, Pageable pageable) {
        return reportRepository.findByStatus(status, pageable).map(this::convertToDto);
    }

    @AdminOnly
    @Transactional
    public ReportDto updateReportStatus(UUID reportId, ReportStatus newStatus) {
        Report report = reportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));

        UUID reportedUserId = report.getReported().getId();
        ReportStatus oldStatus = report.getStatus();

        report.setStatus(newStatus);
        Report updatedReport = reportRepository.save(report);

        if (oldStatus == ReportStatus.SENT && newStatus != ReportStatus.SENT) {
            checkAndUnblockUser(reportedUserId);
        } else if (oldStatus != ReportStatus.SENT && newStatus == ReportStatus.SENT) {
            checkAndBlockUser(reportedUserId);
        }

        return convertToDto(updatedReport);
    }

    @AdminOnly
    @Transactional
    public void deleteReportByAdmin(UUID reportId) {
        Report report = reportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));

        UUID reportedUserId = report.getReported().getId();
        reportRepository.delete(report);

        checkAndUnblockUser(reportedUserId);
    }

    @AdminOnly
    public ReportStatisticsDto getReportsStatistics() {
        ReportStatisticsDto statistics = new ReportStatisticsDto();
        statistics.setTotalReports(reportRepository.count());
        statistics.setSentReports(reportRepository.countByStatus(ReportStatus.SENT));
        statistics.setInProcessReports(reportRepository.countByStatus(ReportStatus.IN_PROCESS));
        statistics.setCompletedReports(reportRepository.countByStatus(ReportStatus.COMPLETED));
        return statistics;
    }

    public List<ReportDto> getUserReports(UUID userId) {
        List<Report> reports = reportRepository.findByReporter_IdOrReported_Id(userId, userId);
        return reports.stream().map(this::convertToDto).collect(Collectors.toList());
    }

    @Transactional
    public ReportDto createReport(UUID reporterId, UUID reportedId, String reason) {
        User reporter = userRepository.findById(reporterId)
                .orElseThrow(() -> new RuntimeException("Reporter not found"));
        User reported = userRepository.findById(reportedId)
                .orElseThrow(() -> new RuntimeException("Reported user not found"));

        if (reporterId.equals(reportedId)) {
            throw new RuntimeException("Нельзя жаловаться на себя");
        }

        Report report = new Report();
        report.setReporter(reporter);
        report.setReported(reported);
        report.setReason(reason);
        report.setStatus(ReportStatus.SENT);

        Report savedReport = reportRepository.save(report);

        checkAndBlockUser(reportedId);

        return convertToDto(savedReport);
    }

    @Transactional
    public void withdrawReport(UUID reportId, UUID userId) {
        Report report = reportRepository.findById(reportId)
                .orElseThrow(() -> new RuntimeException("Report not found"));

        if (!report.getReporter().getId().equals(userId)) {
            throw new RuntimeException("User is not the reporter of this report");
        }

        UUID reportedUserId = report.getReported().getId();
        reportRepository.delete(report);

        checkAndUnblockUser(reportedUserId);
    }

    private void checkAndBlockUser(UUID userId) {
        long sentReportsCount = reportRepository.countByReported_IdAndStatus(userId, ReportStatus.SENT);
        User user = userRepository.findById(userId).orElse(null);
        if (user == null)
            return;

        if (sentReportsCount >= BLOCK_THRESHOLD && !user.getIsBlocked()) {
            user.setIsBlocked(true);
            user.setBlockReason("Автоматическая блокировка: превышено количество жалоб (" + sentReportsCount + "/"
                    + BLOCK_THRESHOLD + ")");
            userRepository.save(user);
            log.info("Пользователь {} заблокирован из-за {} жалоб (порог {})", userId, sentReportsCount,
                    BLOCK_THRESHOLD);

            sessionService.forceLogoutAllUserSessions(userId);
        }
    }

    private void checkAndUnblockUser(UUID userId) {
        long sentReportsCount = reportRepository.countByReported_IdAndStatus(userId, ReportStatus.SENT);
        User user = userRepository.findById(userId).orElse(null);
        if (user == null)
            return;

        if (user.getIsBlocked() && sentReportsCount < BLOCK_THRESHOLD) {
            if (user.getBlockReason() != null && user.getBlockReason().startsWith("Автоматическая блокировка")) {
                user.setIsBlocked(false);
                user.setBlockReason(null);
                userRepository.save(user);
                log.info("Пользователь {} разблокирован, количество жалоб снизилось до {}", userId, sentReportsCount);
            }
        }
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