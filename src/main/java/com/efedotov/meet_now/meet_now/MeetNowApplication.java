package com.efedotov.meet_now.meet_now;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.scheduling.annotation.EnableScheduling;

@SpringBootApplication
@EnableScheduling
public class MeetNowApplication {
	public static void main(String[] args) {
		SpringApplication.run(MeetNowApplication.class, args);
	}
}
