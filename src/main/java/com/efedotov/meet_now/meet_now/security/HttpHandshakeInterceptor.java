package com.efedotov.meet_now.meet_now.security;

import java.security.Principal;
import java.util.Map;

import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.server.HandshakeInterceptor;

import jakarta.servlet.http.HttpSession;

public class HttpHandshakeInterceptor implements HandshakeInterceptor {

    @Override
    public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
                                   WebSocketHandler wsHandler,
                                   Map<String, Object> attributes) throws Exception {
        if (request instanceof org.springframework.http.server.ServletServerHttpRequest servletRequest) {
            HttpSession session = servletRequest.getServletRequest().getSession(false);
            if (session != null) {
                Principal userPrincipal = servletRequest.getServletRequest().getUserPrincipal();
                if (userPrincipal != null) {
                    attributes.put("user", userPrincipal); 
                    return true;
                }
            }
        }
        return false; 
    }

    @Override
    public void afterHandshake(ServerHttpRequest request, ServerHttpResponse response,
                               WebSocketHandler wsHandler, Exception exception) {
    }
    
}
