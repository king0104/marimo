package com.ssafy.marimo.insurance.repository;

import com.ssafy.marimo.insurance.domain.CarInsurance;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.web.bind.annotation.RestController;

@Repository
public interface CarInsuranceRepository extends CrudRepository<CarInsurance, Integer> {
}
