package com.efedotov.meet_now.meet_now.dto.response.notification;

import java.util.Map;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

public class NotificationDto {
    private String id;
    private String title;
    private String body;
    private Map<String, Object> data;
    private long timestamp;
    private String priority;

    public NotificationDto() {
    }

    public NotificationDto(String id, String title, String body, Map<String, Object> data,
            long timestamp, String priority) {
        this.id = id;
        this.title = title;
        this.body = body;
        this.data = data;
        this.timestamp = timestamp;
        this.priority = priority;
    }

    public NotificationDto(String id, String title, String body,
            long timestamp, String priority) {
        this(id, title, body, null, timestamp, priority);
    }

    public String getId() {
        return id;
    }

    public void setId(String id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getBody() {
        return body;
    }

    public void setBody(String body) {
        this.body = body;
    }

    public Map<String, Object> getData() {
        return data;
    }

    public void setData(Map<String, Object> data) {
        this.data = data;
    }

    public long getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(long timestamp) {
        this.timestamp = timestamp;
    }

    public String getPriority() {
        return priority;
    }

    public void setPriority(String priority) {
        this.priority = priority;
    }

    public String toJson() {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.writeValueAsString(this);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Error serializing notification", e);
        }
    }

    public static NotificationDto fromJson(String json) {
        ObjectMapper mapper = new ObjectMapper();
        try {
            return mapper.readValue(json, NotificationDto.class);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Error deserializing notification", e);
        }
    }
}