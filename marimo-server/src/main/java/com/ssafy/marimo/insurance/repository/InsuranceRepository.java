package com.ssafy.marimo.insurance.repository;

import com.ssafy.marimo.insurance.domain.Insurance;
import jakarta.persistence.criteria.CriteriaBuilder.In;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InsuranceRepository extends CrudRepository<Insurance, Integer> {
    Optional<Insurance> findByName(String name);
}
