package com.efedotov.meet_now.meet_now.repository.gift;

import java.util.List;
import java.util.Optional;
import java.util.UUID;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.efedotov.meet_now.meet_now.model.gift.GiftType;

@Repository
public interface GiftTypeRepository extends JpaRepository<GiftType, UUID> {
    List<GiftType> findAllByOrderByTypeNameAsc();

    Optional<GiftType> findByTypeName(String typeName);
}