package com.ssafy.marimo.car.repository;

import com.ssafy.marimo.car.domain.Dtc;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DtcRepository extends CrudRepository<Dtc, Integer> {

}
