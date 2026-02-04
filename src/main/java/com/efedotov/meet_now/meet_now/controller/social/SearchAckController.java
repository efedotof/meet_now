package com.efedotov.meet_now.meet_now.controller.social;

import com.efedotov.meet_now.meet_now.dto.request.search.TemporaryChatAckRequest;
import com.efedotov.meet_now.meet_now.model.search.MatchDeliveryState;
import com.efedotov.meet_now.meet_now.service.social.SearchQueueService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/v1/search/match-delivery")
@RequiredArgsConstructor
@Tag(name = "Match Delivery", description = "Управление доставкой матчей")
public class SearchAckController {

    private final SearchQueueService searchQueueService;

    @PostMapping("/{chatId}/ack")
    @Operation(summary = "Подтверждение получения временного чата")
    public ResponseEntity<Void> acknowledgeTemporaryChat(
            @PathVariable UUID chatId,
            @RequestBody TemporaryChatAckRequest request) {

        searchQueueService.acknowledgeTemporaryChat(chatId, request.getUserId());
        return ResponseEntity.ok().build();
    }

    @GetMapping("/{chatId}/status")
    @Operation(summary = "Получить статус доставки матча")
    public ResponseEntity<MatchDeliveryState> getDeliveryStatus(@PathVariable UUID chatId) {
        MatchDeliveryState status = searchQueueService.getMatchDeliveryStatus(chatId);
        return ResponseEntity.ok(status);
    }

    @GetMapping("/user/{userId}/pending")
    @Operation(summary = "Получить ожидающие подтверждения матчи пользователя")
    public ResponseEntity<List<MatchDeliveryState>> getPendingMatches(
            @PathVariable UUID userId) {

        List<MatchDeliveryState> pendingMatches = searchQueueService
                .getPendingMatchesForUser(userId);
        return ResponseEntity.ok(pendingMatches);
    }

    @DeleteMapping("/{chatId}/cancel")
    @Operation(summary = "Отменить доставку матча")
    public ResponseEntity<Void> cancelMatchDelivery(@PathVariable UUID chatId) {
        searchQueueService.cancelMatchDelivery(chatId);
        return ResponseEntity.ok().build();
    }
}
