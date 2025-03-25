package com.ssafy.marimo.payment.mapper;

import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.payment.domain.Payment;
import com.ssafy.marimo.payment.dto.PaymentItemDto;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
public class PaymentItemMapper {
    private final IdEncryptionUtil idEncryptionUtil;

    public PaymentItemDto toDto(Payment payment) {
        String type = payment.getClass().getSimpleName().replace("Payment", "").toUpperCase();
        return PaymentItemDto.builder()
                .paymentId(idEncryptionUtil.encrypt(payment.getId()))
                .type(type)
                .price(payment.getPrice())
                .paymentDate(payment.getPaymentDate())
                .build();
    }
}
