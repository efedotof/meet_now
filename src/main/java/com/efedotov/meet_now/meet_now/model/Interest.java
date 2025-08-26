package com.efedotov.meet_now.meet_now.model;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "global_interests")
public class Interest {
   @Id
   @GeneratedValue
   private UUID id;
   
   @Column(name = "title")
   private String title;
}
