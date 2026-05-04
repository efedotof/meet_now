package com.efedotov.meet_now.meet_now.controller.chat;

import java.security.Principal;
import java.util.List;
import java.util.Optional;
import java.util.UUID;
import java.util.stream.Collectors;

import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;

import com.efedotov.meet_now.meet_now.dto.request.chat.AgreeChatWebSocketRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.ChatMessagesRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.ContinueChatProposalRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.ContinueChatResponseRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.MarkMessagesReadRequest;
import com.efedotov.meet_now.meet_now.dto.request.chat.PaginatedMessagesRequest;
import com.efedotov.meet_now.meet_now.dto.response.chat.AgreeChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.ContinueChatProposalResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.ContinueChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.MessageDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.PaginatedMessagesResponse;
import com.efedotov.meet_now.meet_now.dto.response.chat.PermanentChatResponseDto;
import com.efedotov.meet_now.meet_now.dto.response.chat.TemporaryChatDto;
import com.efedotov.meet_now.meet_now.dto.response.social.UserActivityDto;
import com.efedotov.meet_now.meet_now.model.chat.TemporaryChat;
import com.efedotov.meet_now.meet_now.security.CustomUserDetails;
import com.efedotov.meet_now.meet_now.service.chat.ActivityNotificationService;
import com.efedotov.meet_now.meet_now.service.chat.ChatQueryService;
import com.efedotov.meet_now.meet_now.service.chat.ChatService;
import com.efedotov.meet_now.meet_now.service.chat.MessageProcessingService;
import com.efedotov.meet_now.meet_now.service.chat.MessageQueryService;
import com.efedotov.meet_now.meet_now.service.chat.PermanentChatUpdateService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequiredArgsConstructor
public class ChatWebSocketController {

    private final MessageProcessingService messageProcessingService;
    private final MessageQueryService messageQueryService;
    private final ChatQueryService chatQueryService;
    private final ActivityNotificationService activityNotificationService;
    private final SimpMessagingTemplate messagingTemplate;
    private final PermanentChatUpdateService permanentChatUpdateService;
    private final ChatService chatService;

    @MessageMapping("/chat.sendMessage")
    public void sendMessage(@Payload MessageDto messageDto, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();

        UUID senderId = userDetails.getUserId();
        messageDto.setSenderId(senderId);

        log.info("Received sendMessage request from userId={} to chatId={}, message={}",
                senderId, messageDto.getChatId(), messageDto.getText());
        messageProcessingService.processMessageDto(messageDto);
        log.info("Processed sendMessage for chatId={}", messageDto.getChatId());
    }

    @MessageMapping("/chat.getMessages")
    public void getChatMessages(@Payload ChatMessagesRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getMessages request: chatId={}, userId={}, username={}",
                request.getChatId(), userId, username);

        messageQueryService.sendMessagesForChatToUser(request.getChatId(), username);
        log.info("Sent messages for chatId={} to username={}", request.getChatId(), username);
    }

    @MessageMapping("/chat.getActiveTemporary")
    public void getActiveTemporaryChats(Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getActiveTemporary request from userId={}", userId);
        List<TemporaryChatDto> chats = chatQueryService.getActiveTemporaryChats(userId).stream()
                .map(chat -> mapTemporaryToDto(chat, userId))
                .collect(Collectors.toList());
        log.info("Returning {} active temporary chats to username={}", chats.size(), username);
        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.temporary.active",
                chats);
    }

    @MessageMapping("/chat.getPermanent")
    public void getPermanentChats(Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getPermanent request from userId={}", userId);

        List<PermanentChatResponseDto> chatDtos = chatQueryService.getPermanentChatsAsDto(userId);
        log.info("Returning {} permanent chats to username={}", chatDtos.size(), username);

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.permanent",
                chatDtos);
    }

    @MessageMapping("/chat.activity")
    public void handleUserActivity(@Payload UserActivityDto activityDto, Principal principal) {
        activityNotificationService.sendActivityNotification(activityDto);
    }

    private TemporaryChatDto mapTemporaryToDto(TemporaryChat chat, UUID currentUserId) {
        TemporaryChatDto dto = new TemporaryChatDto();
        dto.setTempChatId(chat.getTempChatId());
        dto.setSenderId(chat.getSender().getId());
        dto.setRecipientId(chat.getRecipient().getId());
        dto.setCreatedAt(chat.getCreatedAt());
        dto.setDurationMinutes(chat.getDurationMinutes());
        dto.setIsFinished(chat.getIsFinished());
        dto.setBothAgreed(chat.getBothAgreed());
        dto.setSenderAgreed(chat.getSenderAgreed());
        dto.setRecipientAgreed(chat.getRecipientAgreed());

        if (currentUserId.equals(chat.getSender().getId())) {
            dto.setEncryptedAesKey(chat.getEncryptedAesKeyForSender());
        } else if (currentUserId.equals(chat.getRecipient().getId())) {
            dto.setEncryptedAesKey(chat.getEncryptedAesKeyForRecipient());
        }

        return dto;
    }

    @MessageMapping("/chat.getMessages.paginated")
    public void getPaginatedMessages(@Payload PaginatedMessagesRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();
        String username = principal.getName();

        log.info("Received getPaginatedMessages request: chatId={}, page={}, size={}, userId={}",
                request.getChatId(), request.getPage(), request.getSize(), userId);

        PaginatedMessagesResponse response = messageQueryService.getPaginatedMessagesForChat(
                request.getChatId(), request.getPage(), request.getSize());

        messagingTemplate.convertAndSendToUser(
                username,
                "queue/chat.messages.paginated",
                response);

        log.info("Sent paginated messages for chatId={}, page={} to username={}",
                request.getChatId(), request.getPage(), username);
    }

    @MessageMapping("/chat.markAsRead")
    public void markMessagesAsRead(
            @Payload MarkMessagesReadRequest request,
            Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();

        log.info("Marking messages as read by user: {}, message IDs: {}",
                userId, request.getMessageIds());

        messageProcessingService.markMessagesAsRead(request.getMessageIds(), userId);
    }

    @MessageMapping("/chat.subscribeNewTemporary")
    public void subscribeToNewTemporaryChats(Principal principal) {
        String username = principal.getName();
        log.info("Пользователь {} подписался на получение новых временных чатов", username);
    }

    @MessageMapping("/chat.subscribePermanent")
    public void subscribeToPermanentChats(Principal principal) {
        String username = principal.getName();
        log.info("Пользователь {} подписался на получение обновлений постоянных чатов", username);

        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID userId = userDetails.getUserId();

        permanentChatUpdateService.sendUpdatedPermanentChats(userId);
    }

    @MessageMapping("/chat.agreeToContinue")
    public void agreeToContinue(@Payload AgreeChatWebSocketRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID authenticatedUserId = userDetails.getUserId();

        if (!authenticatedUserId.equals(request.getUserId())) {
            log.warn("Пользователь {} пытается согласиться от имени {}", authenticatedUserId, request.getUserId());
            return;
        }

        log.info("Получено согласие на продолжение чата: tempChatId={}, userId={}",
                request.getTempChatId(), request.getUserId());

        try {
            chatService.agreeToContinue(request.getTempChatId(), request.getUserId());

            TemporaryChat updatedChat = chatService.getTemporaryChatById(request.getTempChatId())
                    .orElseThrow(() -> new RuntimeException("Чат не найден"));

            AgreeChatResponseDto response = new AgreeChatResponseDto();
            response.setTempChatId(request.getTempChatId());
            response.setUserId(request.getUserId());
            response.setSenderAgreed(updatedChat.getSenderAgreed());
            response.setRecipientAgreed(updatedChat.getRecipientAgreed());
            response.setBothAgreed(updatedChat.getBothAgreed());
            response.setSuccess(true);

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.agree.response",
                    response);

            UUID otherUserId = getOtherUserId(updatedChat, request.getUserId());
            String otherUserUsername = getUsernameById(otherUserId);

            if (otherUserUsername != null) {
                messagingTemplate.convertAndSendToUser(
                        otherUserUsername,
                        "/queue/chat.agree.notification",
                        response);
            }

            if (Boolean.TRUE.equals(updatedChat.getBothAgreed())) {
                PermanentChatResponseDto permanentChatDto = createPermanentChatFromTemporary(updatedChat);

                if (permanentChatDto != null) {
                    response.setPermanentChat(permanentChatDto);
                    response.setPermanentChatCreated(true);

                    messagingTemplate.convertAndSendToUser(
                            userDetails.getUsername(),
                            "/queue/chat.agree.response",
                            response);

                    if (otherUserUsername != null) {
                        messagingTemplate.convertAndSendToUser(
                                otherUserUsername,
                                "/queue/chat.agree.notification",
                                response);
                    }

                    messagingTemplate.convertAndSendToUser(
                            userDetails.getUsername(),
                            "/queue/chat.permanent.created",
                            permanentChatDto);

                    if (otherUserUsername != null) {
                        messagingTemplate.convertAndSendToUser(
                                otherUserUsername,
                                "/queue/chat.permanent.created",
                                permanentChatDto);
                    }

                    log.info("Постоянный чат создан и пользователи уведомлены: tempChatId={}",
                            request.getTempChatId());
                }
            }

            log.info("Согласие на продолжение чата обработано успешно: tempChatId={}", request.getTempChatId());

        } catch (RuntimeException e) {
            log.error("Ошибка при обработке согласия на продолжение чата: {}", e.getMessage());

            AgreeChatResponseDto errorResponse = new AgreeChatResponseDto();
            errorResponse.setTempChatId(request.getTempChatId());
            errorResponse.setUserId(request.getUserId());
            errorResponse.setSuccess(false);
            errorResponse.setErrorMessage(e.getMessage());

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.agree.response",
                    errorResponse);
        }
    }

    @MessageMapping("/chat.proposeContinue")
    public void proposeContinueChat(@Payload ContinueChatProposalRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID authenticatedUserId = userDetails.getUserId();

        if (!authenticatedUserId.equals(request.getFromUserId())) {
            log.warn("Пользователь {} пытается отправить предложение от имени {}",
                    authenticatedUserId, request.getFromUserId());
            return;
        }

        log.info("Получено предложение продолжить общение: tempChatId={}, fromUserId={}, message={}",
                request.getTempChatId(), request.getFromUserId(), request.getMessage());

        try {
            TemporaryChat tempChat = chatService.getTemporaryChatById(request.getTempChatId())
                    .orElseThrow(() -> new RuntimeException("Временный чат не найден"));

            if (Boolean.TRUE.equals(tempChat.getIsFinished())) {
                throw new RuntimeException("Чат уже завершен");
            }

            if (!tempChat.getSender().getId().equals(request.getFromUserId()) &&
                    !tempChat.getRecipient().getId().equals(request.getFromUserId())) {
                throw new RuntimeException("Пользователь не является участником чата");
            }

            UUID otherUserId = getOtherUserId(tempChat, request.getFromUserId());
            String otherUserUsername = getUsernameById(otherUserId);

            ContinueChatProposalResponseDto proposal = new ContinueChatProposalResponseDto();
            proposal.setTempChatId(request.getTempChatId());
            proposal.setFromUserId(request.getFromUserId());
            proposal.setToUserId(otherUserId);
            proposal.setMessage(request.getMessage());
            proposal.setTimestamp(System.currentTimeMillis());

            messagingTemplate.convertAndSendToUser(
                    otherUserUsername,
                    "/queue/chat.continue.proposal",
                    proposal);

            log.info("Предложение продолжить общение отправлено пользователю {} от пользователя {}",
                    otherUserUsername, userDetails.getUsername());

        } catch (RuntimeException e) {
            log.error("Ошибка при отправке предложения продолжить общение: {}", e.getMessage());

            ContinueChatProposalResponseDto errorResponse = new ContinueChatProposalResponseDto();
            errorResponse.setTempChatId(request.getTempChatId());
            errorResponse.setFromUserId(request.getFromUserId());
            errorResponse.setMessage("Ошибка: " + e.getMessage());
            errorResponse.setTimestamp(System.currentTimeMillis());

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.continue.proposal.error",
                    errorResponse);
        }
    }

    @MessageMapping("/chat.respondContinue")
    public void respondToContinueChat(@Payload ContinueChatResponseRequest request, Principal principal) {
        CustomUserDetails userDetails = (CustomUserDetails) ((Authentication) principal).getPrincipal();
        UUID authenticatedUserId = userDetails.getUserId();

        if (!authenticatedUserId.equals(request.getUserId())) {
            log.warn("Пользователь {} пытается ответить от имени {}", authenticatedUserId, request.getUserId());
            return;
        }

        log.info("Получен ответ на предложение продолжить общение: tempChatId={}, userId={}, accepted={}",
                request.getTempChatId(), request.getUserId(), request.isAccepted());

        try {
            TemporaryChat tempChat = chatService.getTemporaryChatById(request.getTempChatId())
                    .orElseThrow(() -> new RuntimeException("Временный чат не найден"));

            if (Boolean.TRUE.equals(tempChat.getIsFinished())) {
                throw new RuntimeException("Чат уже завершен");
            }

            if (!tempChat.getSender().getId().equals(request.getUserId()) &&
                    !tempChat.getRecipient().getId().equals(request.getUserId())) {
                throw new RuntimeException("Пользователь не является участником чата");
            }

            ContinueChatResponseDto response = new ContinueChatResponseDto();
            response.setTempChatId(request.getTempChatId());
            response.setUserId(request.getUserId());
            response.setAccepted(request.isAccepted());

            if (request.isAccepted()) {
                chatService.agreeToContinue(request.getTempChatId(), request.getUserId());

                TemporaryChat updatedChat = chatService.getTemporaryChatById(request.getTempChatId())
                        .orElseThrow(() -> new RuntimeException("Чат не найден"));

                if (Boolean.TRUE.equals(updatedChat.getBothAgreed())) {
                    PermanentChatResponseDto permanentChatDto = createPermanentChatFromTemporary(updatedChat);
                    response.setPermanentChat(permanentChatDto);
                    response.setPermanentChatCreated(true);
                }

                UUID otherUserId = getOtherUserId(updatedChat, request.getUserId());
                String otherUserUsername = getUsernameById(otherUserId);

                if (otherUserUsername != null) {
                    messagingTemplate.convertAndSendToUser(
                            otherUserUsername,
                            "/queue/chat.continue.response",
                            response);
                }
            } else {
                UUID otherUserId = getOtherUserId(tempChat, request.getUserId());
                String otherUserUsername = getUsernameById(otherUserId);

                if (otherUserUsername != null) {
                    messagingTemplate.convertAndSendToUser(
                            otherUserUsername,
                            "/queue/chat.continue.response",
                            response);
                }
            }

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.continue.response.confirm",
                    response);

            log.info("Ответ на предложение продолжить общение обработан: tempChatId={}, accepted={}",
                    request.getTempChatId(), request.isAccepted());

        } catch (RuntimeException e) {
            log.error("Ошибка при обработке ответа на предложение продолжить общение: {}", e.getMessage());

            ContinueChatResponseDto errorResponse = new ContinueChatResponseDto();
            errorResponse.setTempChatId(request.getTempChatId());
            errorResponse.setUserId(request.getUserId());
            errorResponse.setAccepted(false);
            errorResponse.setErrorMessage(e.getMessage());

            messagingTemplate.convertAndSendToUser(
                    userDetails.getUsername(),
                    "/queue/chat.continue.response.error",
                    errorResponse);
        }
    }

    private PermanentChatResponseDto createPermanentChatFromTemporary(TemporaryChat tempChat) {
        try {
            chatService.createPermanentChatFromTemporary(tempChat);

            Optional<PermanentChatResponseDto> permanentChatOpt = chatQueryService.getPermanentChatByUsers(
                    tempChat.getSender().getId(),
                    tempChat.getRecipient().getId());

            if (permanentChatOpt.isPresent()) {
                PermanentChatResponseDto permanentChatDto = permanentChatOpt.get();

                permanentChatUpdateService.sendUpdatedPermanentChats(tempChat.getSender().getId());
                permanentChatUpdateService.sendUpdatedPermanentChats(tempChat.getRecipient().getId());

                log.info("Постоянный чат создан: {}", tempChat.getTempChatId());

                return permanentChatDto;
            }
        } catch (RuntimeException e) {
            log.error("Ошибка при создании постоянного чата из временного: {}", e.getMessage());
        }
        return null;
    }

    private UUID getOtherUserId(TemporaryChat chat, UUID currentUserId) {
        if (chat.getSender().getId().equals(currentUserId)) {
            return chat.getRecipient().getId();
        } else {
            return chat.getSender().getId();
        }
    }

    private String getUsernameById(UUID userId) {
        try {
            return chatService.getUserById(userId)
                    .map(user -> user.getUsername())
                    .orElse(null);
        } catch (Exception e) {
            log.error("Ошибка при получении username для userId={}: {}", userId, e.getMessage());
            return null;
        }
    }

}