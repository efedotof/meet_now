package com.efedotov.meet_now.meet_now.config;

import java.util.Map;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Configuration
@ConfigurationProperties(prefix = "game.urls")
public class GameConfig {
    private Map<String, String> urls;
    private Map<String, Double> scores;

    public int convertScoreToPoints(String gameType, int score) {
        Double multiplier = scores.getOrDefault(gameType, 0.05);
        return (int) (score * multiplier);
    }

    public Map<String, String> getUrls() {
        return urls;
    }

    public void setUrls(Map<String, String> urls) {
        this.urls = urls;
    }

    public Map<String, Double> getScores() {
        return scores;
    }

    public void setScores(Map<String, Double> scores) {
        this.scores = scores;
    }

    public String getUrl(String gameType) {
        return urls.getOrDefault(gameType, "");
    }

    public Map<String, String> getAllUrls() {
        return urls;
    }
}
