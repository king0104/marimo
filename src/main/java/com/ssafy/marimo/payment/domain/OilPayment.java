package com.ssafy.marimo.payment.domain;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.domain.FuelType;
import com.ssafy.marimo.payment.dto.request.PatchOilPaymentRequest;
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

@Getter
@Entity
@Table(name = "oil_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("OIL")
public class OilPayment extends Payment {

    @Enumerated(EnumType.STRING)
    @Column(nullable = true, length = 50)
    private FuelType fuelType;

    @Builder
    private OilPayment(Car car, Integer price, LocalDateTime paymentDate, String location, String memo, FuelType fuelType) {
        super(car, price, paymentDate, location, memo);
        this.fuelType = fuelType;
    }

    public static OilPayment create(Car car, Integer price, String location, String memo, FuelType fuelType) {
        return OilPayment.builder()
                .car(car)
                .price(price)
                .location(location)
                .memo(memo)
                .fuelType(fuelType)
                .build();
    }

    private void changeFuelType(FuelType fuelType) {
        if (fuelType != null) this.fuelType = fuelType;
    }

    public void updateFromRequestDto(PatchOilPaymentRequest patchOilPaymentRequest) {
        changePayment(patchOilPaymentRequest.price(), patchOilPaymentRequest.paymentDate(), patchOilPaymentRequest.location(), patchOilPaymentRequest.memo());
        changeFuelType(patchOilPaymentRequest.fuelType());
    }
}
