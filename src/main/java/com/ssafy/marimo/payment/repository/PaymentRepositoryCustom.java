package com.ssafy.marimo.payment.repository;

import com.ssafy.marimo.payment.domain.Payment;
import java.util.List;

// PaymentRepositoryCustom.java
public interface PaymentRepositoryCustom {
    List<Payment> findByCarIdAndYearMonth(Integer carId, int year, int month);
}
