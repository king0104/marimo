package com.ssafy.marimo.insurance.repository;

import com.ssafy.marimo.insurance.domain.InsuranceDiscountRule;
import java.util.List;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface InsuranceDiscountRuleRepository extends CrudRepository<InsuranceDiscountRule, Integer> {
    List<InsuranceDiscountRule> findByInsuranceIdOrderByDiscountFromKm(Integer insuranceId);
}
