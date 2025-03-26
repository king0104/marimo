package com.ssafy.marimo.car.repository;

import com.ssafy.marimo.car.domain.Car;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CarRepository extends CrudRepository<Car, Integer> {

}
