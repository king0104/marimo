package com.ssafy.marimo.car.repository;

import com.ssafy.marimo.car.domain.Obd2;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface Obd2Repository extends CrudRepository<Obd2, Integer> {


}
