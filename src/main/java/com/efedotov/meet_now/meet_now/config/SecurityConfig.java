package com.efedotov.meet_now.meet_now.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.efedotov.meet_now.meet_now.security.AdminAccessDeniedHandler;
import com.efedotov.meet_now.meet_now.security.AdminAuthenticationEntryPoint;
import com.efedotov.meet_now.meet_now.security.SessionAuthFilter;

import lombok.RequiredArgsConstructor;

@Configuration
@EnableWebSecurity
@EnableMethodSecurity(prePostEnabled = true)
@RequiredArgsConstructor
public class SecurityConfig {

        private final SessionAuthFilter sessionAuthFilter;
        private final AdminAccessDeniedHandler adminAccessDeniedHandler;
        private final AdminAuthenticationEntryPoint adminAuthenticationEntryPoint;

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http
                                .csrf(csrf -> csrf.disable())
                                .cors(cors -> cors.disable())
                                .sessionManagement(session -> session
                                                .sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                                .authorizeHttpRequests(authz -> authz
                                                .requestMatchers(
                                                                "/api/v1/auth/**",
                                                                "/api/v1/purpAndInt/**",
                                                                "/api/v1/cities/**",
                                                                "/swagger-ui/**",
                                                                "/v3/api-docs/**",
                                                                "/swagger-resources/**",
                                                                "/webjars/**",
                                                                "/api/v1/test",
                                                                "/api/v1/auth/token/validate-token",
                                                                "/error",
                                                                "/ws/**",
                                                                "/app/**",
                                                                "/topic/**",
                                                                "/api/v1/document/**",
                                                                "/queue/**")
                                                .permitAll()

                                                .requestMatchers("/api/v1/user/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/friend/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/support/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/reports/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/admin/statistics/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/gifts/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/games/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/cities/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/icebreaker/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/purpAndInt/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/stickers/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/chat/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/auth/token/admin/**").hasRole("ADMIN")
                                                .requestMatchers("/api/v1/search/admin/**").hasRole("ADMIN")

                                                .requestMatchers("/api/v1/user/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/search/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/friend/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/chat/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/games/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/gifts/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/reports/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/support/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/stickers/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/icebreaker/**").hasAnyRole("USER", "ADMIN")

                                                .anyRequest().authenticated())
                                .exceptionHandling(exceptions -> exceptions
                                                .authenticationEntryPoint(adminAuthenticationEntryPoint)
                                                .accessDeniedHandler(adminAccessDeniedHandler))
                                .addFilterBefore(sessionAuthFilter, UsernamePasswordAuthenticationFilter.class);

                return http.build();
        }

        @Bean
        public PasswordEncoder passwordEncoder() {
                return new BCryptPasswordEncoder();
        }

        @Bean
        public AuthenticationManager authenticationManager(AuthenticationConfiguration config) throws Exception {
                return config.getAuthenticationManager();
        }
}