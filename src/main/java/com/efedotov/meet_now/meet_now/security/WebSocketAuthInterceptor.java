package com.efedotov.meet_now.meet_now.security;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.lang.NonNull;
import org.springframework.messaging.Message;
import org.springframework.messaging.MessageChannel;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.ChannelInterceptor;
import org.springframework.messaging.support.MessageHeaderAccessor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.efedotov.meet_now.meet_now.model.user.UserSession;
import com.efedotov.meet_now.meet_now.service.auth.SessionService;
import com.efedotov.meet_now.meet_now.service.auth.UserDetailsServiceImpl;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
@RequiredArgsConstructor
public class WebSocketAuthInterceptor implements ChannelInterceptor {
    private final SessionService sessionService;
    private final UserDetailsServiceImpl userDetailsService;

    @Override
    public Message<?> preSend(@NonNull Message<?> message, @NonNull MessageChannel channel) {
        StompHeaderAccessor accessor = MessageHeaderAccessor.getAccessor(message, StompHeaderAccessor.class);
        if (accessor != null && StompCommand.CONNECT.equals(accessor.getCommand())) {
            try {
                List<String> authHeaders = accessor.getNativeHeader("Authorization");
                String token = null;

                if (authHeaders != null && !authHeaders.isEmpty()) {
                    String bearerToken = authHeaders.get(0);
                    if (bearerToken.startsWith("Bearer ")) {
                        token = bearerToken.substring(7);

                    } else {
                        log.warn("Authorization header does not start with 'Bearer '");
                    }
                }

                if (token == null) {
                    log.error("No Authorization token found in headers");
                    throw new RuntimeException("Authorization header is missing");
                }

                Optional<UserSession> sessionOpt = sessionService.findByToken(token);
                if (!sessionOpt.isPresent()) {
                    throw new RuntimeException("Invalid token");
                }

                UUID userId = sessionOpt.get().getUserId();
                log.info("Authenticating user ID: {}", userId);

                UserDetails userDetails = userDetailsService.loadUserById(userId);
                log.info("Loaded UserDetails: {}", userDetails.getClass().getName());

                if (!(userDetails instanceof CustomUserDetails)) {
                    log.error("UserDetails is not CustomUserDetails. Actual type: {}",
                            userDetails.getClass().getName());
                    throw new RuntimeException("Invalid UserDetails implementation");
                }

                CustomUserDetails customDetails = (CustomUserDetails) userDetails;
                log.info("User authenticated: {}", customDetails.getUsername());

                UsernamePasswordAuthenticationToken auth = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());

                SecurityContextHolder.getContext().setAuthentication(auth);
                accessor.setUser(auth);
                return message;

            } catch (RuntimeException e) {
                log.error("WebSocket authentication failed", e);
                throw e;
            }
        }
        return message;
    }
}