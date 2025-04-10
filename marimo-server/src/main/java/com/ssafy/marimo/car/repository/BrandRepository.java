package com.ssafy.marimo.car.repository;

import com.ssafy.marimo.car.domain.Brand;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BrandRepository extends CrudRepository<Brand, Integer> {
    Optional<Brand> findByName(String name);

}
