package com.efedotov.meet_now.meet_now;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

import de.codecentric.boot.admin.server.config.EnableAdminServer;

@SpringBootApplication
@EnableScheduling
@EnableAdminServer
public class MeetNowApplication {
	public static void main(String[] args) {
		SpringApplication.run(MeetNowApplication.class, args);
	}
}

