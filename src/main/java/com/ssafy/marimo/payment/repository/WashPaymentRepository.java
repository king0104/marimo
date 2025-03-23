package com.ssafy.marimo.payment.repository;

import com.ssafy.marimo.payment.domain.WashPayment;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface WashPaymentRepository extends CrudRepository<WashPayment, Integer> {

}
