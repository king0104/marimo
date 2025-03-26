package com.ssafy.marimo.payment.domain;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.payment.dto.request.PatchRepairPaymentRequest;
import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@Table(name = "repair_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("REPAIR")
public class RepairPayment extends Payment {

    @Column(nullable = true, length = 50)
    private String repairPart;

    @Builder
    private RepairPayment(Car car, Integer price, LocalDateTime paymentDate, String location, String memo, String repairPart) {
        super(car, price, paymentDate, location, memo);
        this.repairPart = repairPart;
    }

    public static RepairPayment create(Car car, Integer price, LocalDateTime paymentDate, String location, String memo, String repairPart) {
        return RepairPayment.builder()
                .car(car)
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .repairPart(repairPart)
                .build();
    }

    private void changeRepairPart(String repairPart) {
        if (repairPart != null) this.repairPart = repairPart;
    }

    public void updateFromRequestDto(PatchRepairPaymentRequest patchRepairPaymentRequest) {
        changePayment(patchRepairPaymentRequest.price(), patchRepairPaymentRequest.paymentDate(), patchRepairPaymentRequest.location(), patchRepairPaymentRequest.memo());
        changeRepairPart(patchRepairPaymentRequest.repairPart());
    }

}
