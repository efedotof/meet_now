package com.efedotov.meet_now.meet_now.controller.purp_and_inter;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.efedotov.meet_now.meet_now.service.PurpAndIntService;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;

@RestController
@RequestMapping("/api/v1/purpAndInt")
@Tag(name = "Интересы и Цели", description = "Эндпоинты для получения всех интересов и целей")
@RequiredArgsConstructor
public class PurposeAndInteresController {
    
    private final PurpAndIntService purpAndIntService;

    @GetMapping("/getInterest")
    @Operation(summary = "Получить все интересы")
    public ResponseEntity<?> getInterest(){
        try{
            return ResponseEntity.ok(purpAndIntService.getAllInterest());
        }catch(Exception e){
            return ResponseEntity.status(500).body("Что-то пошло не так: " + e.getMessage());
        }
    }

    @GetMapping("/getPurpose")
    @Operation(summary = "Получить все цели")
    public ResponseEntity<?> getPurpose(){
        try{
            return ResponseEntity.ok(purpAndIntService.getAllPurpose());
        }catch(Exception e){
            return ResponseEntity.status(500).body("Что-то пошло не так: " + e.getMessage());
        }
    }
}
