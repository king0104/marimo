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

        return PaymentItemDto.of(
                idEncryptionUtil.encrypt(payment.getId()),
                type,
                payment.getPrice(),
                payment.getPaymentDate());
    }
}
