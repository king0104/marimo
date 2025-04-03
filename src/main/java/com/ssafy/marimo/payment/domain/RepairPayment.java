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
    private String repairParts;

    @Builder
    private RepairPayment(Car car, Integer price, LocalDateTime paymentDate, String location, String memo, String repairParts) {
        super(car, price, paymentDate, location, memo);
        this.repairParts = repairParts;
    }

    public static RepairPayment create(Car car, Integer price, LocalDateTime paymentDate, String location, String memo, String repairParts) {
        return RepairPayment.builder()
                .car(car)
                .price(price)
                .paymentDate(paymentDate)
                .location(location)
                .memo(memo)
                .repairParts(repairParts)
                .build();
    }

    private void changeRepairParts(String repairParts) {
        if (repairParts != null) this.repairParts = repairParts;
    }

    public void updateFromRequestDto(PatchRepairPaymentRequest patchRepairPaymentRequest) {
        changePayment(patchRepairPaymentRequest.price(), patchRepairPaymentRequest.paymentDate(), patchRepairPaymentRequest.location(), patchRepairPaymentRequest.memo());
        changeRepairParts(patchRepairPaymentRequest.repairParts());
    }

}
