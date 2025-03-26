package com.ssafy.marimo.payment.repository;

import com.ssafy.marimo.payment.domain.Payment;
import org.springframework.data.repository.CrudRepository;

// PaymentRepository.java
public interface PaymentRepository extends CrudRepository<Payment, Integer>, PaymentRepositoryCustom {
}