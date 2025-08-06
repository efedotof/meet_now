package com.efedotov.meet_now.meet_now.service.user;

import java.util.List;
import java.util.UUID;

import org.springframework.data.jpa.domain.Specification;

import com.efedotov.meet_now.meet_now.model.User;

import jakarta.persistence.criteria.Join;
import jakarta.persistence.criteria.JoinType;

public class UserSpecifications {

    public static Specification<User> hasInterests(List<String> interests) {
        return (root, query, criteriaBuilder) -> {
            if (interests == null || interests.isEmpty())
                return null;

            query.distinct(true);
            Join<User, String> join = root.join("interests", JoinType.INNER);
            return join.in(interests);
        };
    }

    public static Specification<User> hasPurposes(List<String> purposes) {
        return (root, query, criteriaBuilder) -> {
            if (purposes == null || purposes.isEmpty())
                return null;

            query.distinct(true);
            Join<User, String> join = root.join("purposes", JoinType.INNER);
            return join.in(purposes);
        };
    }

    public static Specification<User> isVerified(Boolean verified) {
        return (root, query, criteriaBuilder) -> verified != null
                ? criteriaBuilder.equal(root.get("verified"), verified)
                : null;
    }

    public static Specification<User> hasAgeRange(Integer ageStart, Integer ageStop) {
        return (root, query, criteriaBuilder) -> {
            if (ageStart == null && ageStop == null) {
                return null;
            }

            if (ageStart != null && ageStop != null) {
                return criteriaBuilder.between(root.get("age"), ageStart, ageStop);
            }

            if (ageStart != null) {
                return criteriaBuilder.greaterThanOrEqualTo(root.get("age"), ageStart);
            }

            return criteriaBuilder.lessThanOrEqualTo(root.get("age"), ageStop);
        };
    }

    public static Specification<User> hasCity(String city) {
        return (root, query, criteriaBuilder) -> city != null && !city.isEmpty()
                ? criteriaBuilder.equal(root.get("city"), city)
                : null;
    }

    public static Specification<User> isSearchable() {
        return (root, query, criteriaBuilder) -> criteriaBuilder.isTrue(root.get("isSearchable"));
    }

    public static Specification<User> notCurrentUser(UUID userId) {
        return (root, query, criteriaBuilder) -> criteriaBuilder.notEqual(root.get("id"), userId);
    }

    public static Specification<User> hasFloor(String floor) {
        return (root, query, criteriaBuilder) -> {
            if (floor == null || floor.isEmpty()) {
                return null;
            }
            return criteriaBuilder.like(
                    criteriaBuilder.lower(root.get("floor")),
                    floor.toLowerCase() + "%");
        };
    }

    public static Specification<User> isOnline() {
        return (root, query, criteriaBuilder) -> criteriaBuilder.isTrue(root.get("isOnline"));
    }

    public static Specification<User> isSearching() {
        return (root, query, criteriaBuilder) -> 
            criteriaBuilder.equal(root.get("isSearching"), true);
    }
}