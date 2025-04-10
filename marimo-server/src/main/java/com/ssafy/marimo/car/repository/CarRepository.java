package com.ssafy.marimo.car.repository;

import com.ssafy.marimo.car.domain.Car;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CarRepository extends CrudRepository<Car, Integer> {

    @Query("SELECT c FROM Car c JOIN FETCH c.brand WHERE c.member.id = :memberId")
    List<Car> findCarsByMemberId(@Param("memberId") Integer memberId);


}
