package com.ssafy.marimo.payment.repository;

import com.ssafy.marimo.payment.domain.OilPayment;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface OilPaymentRepository extends CrudRepository<OilPayment, Integer> {

}
