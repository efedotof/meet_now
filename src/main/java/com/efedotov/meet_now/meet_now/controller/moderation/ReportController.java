package com.efedotov.meet_now.meet_now.controller.moderation;

import java.util.List;
import java.util.UUID;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.dto.request.moderation.CreateReportRequest;
import com.efedotov.meet_now.meet_now.dto.request.moderation.UpdateReportStatusRequest;
import com.efedotov.meet_now.meet_now.dto.response.moderation.ReportDto;
import com.efedotov.meet_now.meet_now.dto.response.moderation.ReportStatisticsDto;
import com.efedotov.meet_now.meet_now.model.moderation.ReportStatus;
import com.efedotov.meet_now.meet_now.security.AdminOnly;
import com.efedotov.meet_now.meet_now.service.moderation.ReportService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/reports")
@RequiredArgsConstructor
@Tag(name = "Reports", description = "API для работы с жалобами пользователей")
public class ReportController {

        private final ReportService reportService;

        @Operation(summary = "[АДМИНИСТРАТОР] Получить все жалобы", description = "Возвращает все жалобы с пагинацией. Только для администраторов", responses = {
                        @ApiResponse(responseCode = "200", description = "Список жалоб успешно получен"),
                        @ApiResponse(responseCode = "403", description = "Недостаточно прав")
        })
        @GetMapping("/admin/all")
        @AdminOnly
        public ResponseEntity<Page<ReportDto>> getAllReports(Pageable pageable) {
                Page<ReportDto> reports = reportService.getAllReports(pageable);
                return ResponseEntity.ok(reports);
        }

        @Operation(summary = "[АДМИНИСТРАТОР] Получить жалобы по статусу", description = "Возвращает жалобы с определенным статусом. Только для администраторов", responses = {
                        @ApiResponse(responseCode = "200", description = "Список жалоб успешно получен"),
                        @ApiResponse(responseCode = "403", description = "Недостаточно прав")
        })
        @GetMapping("/admin/status/{status}")
        @AdminOnly
        public ResponseEntity<Page<ReportDto>> getReportsByStatus(
                        @Parameter(description = "Статус жалобы") @PathVariable ReportStatus status,
                        Pageable pageable) {
                Page<ReportDto> reports = reportService.getReportsByStatus(status, pageable);
                return ResponseEntity.ok(reports);
        }

        @Operation(summary = "[АДМИНИСТРАТОР] Изменить статус жалобы", description = "Изменяет статус жалобы. Только для администраторов", responses = {
                        @ApiResponse(responseCode = "200", description = "Статус жалобы успешно изменен"),
                        @ApiResponse(responseCode = "404", description = "Жалоба не найдена"),
                        @ApiResponse(responseCode = "403", description = "Недостаточно прав")
        })
        @PutMapping("/admin/{reportId}/status")
        @AdminOnly
        public ResponseEntity<ReportDto> updateReportStatus(
                        @Parameter(description = "ID жалобы") @PathVariable UUID reportId,
                        @RequestBody UpdateReportStatusRequest request) {
                ReportDto report = reportService.updateReportStatus(reportId, request.getStatus());
                return ResponseEntity.ok(report);
        }

        @Operation(summary = "[АДМИНИСТРАТОР] Удалить жалобу", description = "Удаляет жалобу по ID. Только для администраторов", responses = {
                        @ApiResponse(responseCode = "204", description = "Жалоба успешно удалена"),
                        @ApiResponse(responseCode = "404", description = "Жалоба не найдена"),
                        @ApiResponse(responseCode = "403", description = "Недостаточно прав")
        })
        @DeleteMapping("/admin/{reportId}")
        @AdminOnly
        public ResponseEntity<Void> deleteReportByAdmin(
                        @Parameter(description = "ID жалобы") @PathVariable UUID reportId) {
                reportService.deleteReportByAdmin(reportId);
                return ResponseEntity.noContent().build();
        }

        @Operation(summary = "[АДМИНИСТРАТОР] Получить статистику по жалобам", description = "Возвращает статистику по жалобам. Только для администраторов", responses = {
                        @ApiResponse(responseCode = "200", description = "Статистика успешно получена"),
                        @ApiResponse(responseCode = "403", description = "Недостаточно прав")
        })
        @GetMapping("/admin/statistics")
        @AdminOnly
        public ResponseEntity<ReportStatisticsDto> getReportsStatistics() {
                ReportStatisticsDto statistics = reportService.getReportsStatistics();
                return ResponseEntity.ok(statistics);
        }

        @Operation(summary = "Получить все жалобы пользователя", description = "Возвращает список всех жалоб, где пользователь является отправителем или получателем", responses = {
                        @ApiResponse(responseCode = "200", description = "Список жалоб успешно получен"),
                        @ApiResponse(responseCode = "404", description = "Пользователь не найден")
        })
        @GetMapping("/user/{userId}")
        public ResponseEntity<List<ReportDto>> getUserReports(
                        @Parameter(description = "ID пользователя") @PathVariable UUID userId) {
                List<ReportDto> reports = reportService.getUserReports(userId);
                return ResponseEntity.ok(reports);
        }

        @Operation(summary = "Создать жалобу", description = "Создает новую жалобу со статусом 'Отправлен'", responses = {
                        @ApiResponse(responseCode = "201", description = "Жалоба успешно создана"),
                        @ApiResponse(responseCode = "400", description = "Неверные параметры запроса")
        })
        @PostMapping
        public ResponseEntity<ReportDto> createReport(
                        @RequestBody CreateReportRequest request) {
                ReportDto report = reportService.createReport(
                                request.getReporterId(),
                                request.getReportedId(),
                                request.getReason());
                return ResponseEntity.status(HttpStatus.CREATED).body(report);
        }

        @Operation(summary = "Отозвать жалобу", description = "Удаляет жалобу по ID если пользователь является ее создателем", responses = {
                        @ApiResponse(responseCode = "204", description = "Жалоба успешно удалена"),
                        @ApiResponse(responseCode = "404", description = "Жалоба не найдена"),
                        @ApiResponse(responseCode = "403", description = "Недостаточно прав для удаления жалобы")
        })
        @DeleteMapping("/{reportId}")
        public ResponseEntity<Void> withdrawReport(
                        @Parameter(description = "ID жалобы") @PathVariable UUID reportId,
                        @Parameter(description = "ID пользователя, отзывающего жалобу") @RequestParam UUID userId) {
                reportService.withdrawReport(reportId, userId);
                return ResponseEntity.noContent().build();
        }
}