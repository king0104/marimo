package com.ssafy.marimo.payment.repository;

import com.ssafy.marimo.payment.domain.Payment;
import java.util.List;
import org.springframework.data.repository.CrudRepository;

// PaymentRepository.java
public interface PaymentRepository extends CrudRepository<Payment, Integer>, PaymentRepositoryCustom {
    List<Payment> findByCarId(Integer carId);

}