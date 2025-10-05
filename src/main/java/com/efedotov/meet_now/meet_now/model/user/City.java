package com.efedotov.meet_now.meet_now.model.user;

import java.util.UUID;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import lombok.Data;

@Data
@Entity
@Table(name = "citys")
public class City {
    @Id
    @GeneratedValue
    private UUID id;

    @Column(name = "name_city")
    private String nameCity;
}
