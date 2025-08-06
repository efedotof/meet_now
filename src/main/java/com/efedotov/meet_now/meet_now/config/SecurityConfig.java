package com.efedotov.meet_now.meet_now.config;

import java.util.Arrays;
import java.util.List;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;
import org.springframework.web.filter.CorsFilter;

import com.efedotov.meet_now.meet_now.security.SessionAuthFilter;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class SecurityConfig {
        private final SessionAuthFilter sessionAuthFilter;

        @Bean
        public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
                http.cors(cors -> {
                }).csrf(csrf -> csrf.disable())
                                .authorizeHttpRequests(auth -> auth
                                                .requestMatchers("/api/v1/auth/**").permitAll()
                                                .requestMatchers("/swagger-ui/**", "/v3/api-docs/**",
                                                                "/swagger-resources/**", "/webjars/**")
                                                .permitAll()
                                                .requestMatchers("/uploads/**").permitAll()
                                                .requestMatchers("/api/v1/auth/token/**").permitAll()
                                                .requestMatchers("/api/v1/user/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/api/v1/search/**").hasAnyRole("USER", "ADMIN")
                                                .requestMatchers("/error").permitAll()
                                                .requestMatchers("/ws/**", "/app/**", "/topic/**", "/queue/**")
                                                .permitAll()
                                                .anyRequest().authenticated())
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
        @Bean
        public CorsFilter corsFilter() {
                CorsConfiguration config = new CorsConfiguration();
                config.setAllowCredentials(true);
                config.setAllowedOriginPatterns(List.of(
                                "http://mnapp.ru",
                                "http://www.mnapp.ru",
                                "http://localhost:*",
                                "http://127.0.0.1:*"));
                config.setAllowedHeaders(Arrays.asList(
                                "Origin", "Content-Type", "Accept", "Authorization",
                                "X-Requested-With", "Access-Control-Request-Method",
                                "Access-Control-Request-Headers"));
                config.setExposedHeaders(List.of(
                                "Access-Control-Allow-Origin", "Access-Control-Allow-Credentials"));
                config.setAllowedMethods(Arrays.asList(
                                "GET", "POST", "PUT", "DELETE", "OPTIONS", "PATCH"));
                config.setMaxAge(3600L);

                UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
                source.registerCorsConfiguration("/**", config);

                return new CorsFilter(source);
        }
}
