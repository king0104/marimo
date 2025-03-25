package com.ssafy.marimo.payment.domain;


import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.navigation.WashType;
import com.ssafy.marimo.payment.dto.PatchWashPaymentRequest;
import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Filter;

@Getter
@Entity
@Table(name = "wash_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("WASH")
public class WashPayment extends Payment {

    @Enumerated(EnumType.STRING)
    @Column(nullable = true, length = 50)
    private WashType washType;


    @Builder
    private WashPayment(Car car, Integer price, LocalDateTime paymentDate,  String location, String memo, WashType washType) {
        super(car, price, paymentDate, location, memo);
        this.washType = washType;
    }

    public static WashPayment create(Car car, Integer price, LocalDateTime paymentDate, String location, String memo, WashType washType) {
        return WashPayment.builder()
                .car(car)
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .washType(washType)
                .build();
    }

    private void changeWashType(WashType washType) {
        if (washType != null) this.washType = washType;
    }

    public void updateFromRequestDto(PatchWashPaymentRequest patchWashPaymentRequest) {
        changePayment(patchWashPaymentRequest.price(), patchWashPaymentRequest.paymentDate(), patchWashPaymentRequest.location(), patchWashPaymentRequest.memo());
        changeWashType(patchWashPaymentRequest.washType());
    }
}
