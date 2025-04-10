package com.ssafy.marimo.payment.repository;

import com.ssafy.marimo.payment.domain.RepairPayment;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RepairPaymentRepository extends CrudRepository<RepairPayment, Integer> {
}
