package com.ssafy.marimo.payment.service;

import com.ssafy.marimo.payment.domain.Payment;
import com.ssafy.marimo.payment.dto.response.GetMonthlyPaymentResponse;
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

    public GetMonthlyPaymentResponse getMonthlyHistory(
            Integer carId,
            Integer year,
            Integer month
    ) {
        List<Payment> payments;
        int thisMonthTotal = 0;
        List<PaymentItemDto> items = new ArrayList<>();

        if (year == null || month == null) {
            // 전체 결제 내역 조회
            payments = paymentRepository.findByCarId(carId);
            for (Payment payment : payments) {
                items.add(paymentItemMapper.toDto(payment));
                thisMonthTotal += payment.getPrice();
            }

            return GetMonthlyPaymentResponse.of(
                    thisMonthTotal,
                    0, // 비교 대상이 없으므로 diff는 0
                    items
            );

        } else {
            // 특정 월의 결제 내역 조회
            payments = paymentRepository.findByCarIdAndYearMonth(carId, year, month);
            for (Payment payment : payments) {
                items.add(paymentItemMapper.toDto(payment));
                thisMonthTotal += payment.getPrice();
            }

            // 이전 달 계산
            int lastYear = (month == 1) ? year - 1 : year;
            int lastMonth = (month == 1) ? 12 : month - 1;
            List<Payment> lastMonthPayments = paymentRepository.findByCarIdAndYearMonth(carId, lastYear, lastMonth);

            int lastMonthTotal = 0;
            for (Payment payment : lastMonthPayments) {
                lastMonthTotal += payment.getPrice();
            }

            int diff = thisMonthTotal - lastMonthTotal;

            return GetMonthlyPaymentResponse.of(
                    thisMonthTotal,
                    diff,
                    items
            );
        }
    }

}