
package com.efedotov.meet_now.meet_now.controller.report;

import com.efedotov.meet_now.meet_now.dto.ReportDto;
import com.efedotov.meet_now.meet_now.dto.request.CreateReportRequest;
import com.efedotov.meet_now.meet_now.service.user.ReportService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/reports")
@RequiredArgsConstructor
@Tag(name = "Reports", description = "API для работы с жалобами пользователей")
public class ReportController {

    private final ReportService reportService;

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