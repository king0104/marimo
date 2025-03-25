package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.payment.domain.Payment;
import com.ssafy.marimo.payment.dto.MonthlyPaymentResponse;
import com.ssafy.marimo.payment.dto.PaymentItemDto;
import com.ssafy.marimo.payment.mapper.PaymentItemMapper;
import com.ssafy.marimo.payment.repository.PaymentRepository;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class PaymentService {

    private final PaymentRepository paymentRepository;
    private final PaymentItemMapper paymentItemMapper;

    public MonthlyPaymentResponse getMonthlyHistory(
            Integer carId,
            int year,
            int month
    )
    {
        List<Payment> payments = paymentRepository.findByCarIdAndYearMonth(carId, year, month);

        List<PaymentItemDto> items = new ArrayList<>();
        int thisMonthTotal = 0;

        for (Payment payment : payments) {
            items.add(paymentItemMapper.toDto(payment));
            thisMonthTotal += payment.getPrice();
        }

        int lastYear = (month == 1) ? year - 1 : year;
        int lastMonth = (month == 1) ? 12 : month - 1;
        List<Payment> lastMonthPayments = paymentRepository.findByCarIdAndYearMonth(carId, lastYear, lastMonth);

        int lastMonthTotal = 0;
        for (Payment payment : lastMonthPayments) {
            lastMonthTotal += payment.getPrice();
        }

        int diff = thisMonthTotal - lastMonthTotal;

        return MonthlyPaymentResponse.of(
                thisMonthTotal,
                diff,
                items
        );
    }
}