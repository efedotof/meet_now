package com.efedotov.meet_now.meet_now.until;


import java.time.Duration;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

import org.springframework.stereotype.Component;

@Component
public class DateTimeUtils {

    private static final DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;

    public static String formatDateTime(LocalDateTime dateTime) {
        return dateTime.format(formatter);
    }

    public static LocalDateTime parseDateTime(String dateTimeStr) {
        return LocalDateTime.parse(dateTimeStr, formatter);
    }

    public static boolean isTimeoutExceeded(LocalDateTime startTime, long timeoutMinutes) {
        LocalDateTime now = LocalDateTime.now();
        Duration duration = Duration.between(startTime, now);
        return duration.toMinutes() >= timeoutMinutes;
    }

    public static LocalDateTime getTimeoutEnd(LocalDateTime startTime, long timeoutMinutes) {
        return startTime.plusMinutes(timeoutMinutes);
    }

}
