package com.ssafy.marimo.payment.domain;

import com.ssafy.marimo.car.domain.Car;
import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.Filter;

@Getter
@Entity
@Table(name = "repair_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("REPAIR")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class RepairPayment extends Payment {

    @Column(nullable = true, length = 50)
    private String repairPart;


    @Builder
    public RepairPayment(Car car, Integer price, String location, String memo, String repairPart) {
        super(car, price, location, memo);
        this.repairPart = repairPart;
    }

    public static RepairPayment create(Car car, Integer price, String location, String memo, String repairPart) {
        return RepairPayment.builder()
                .car(car)
                .price(price)
                .location(location)
                .memo(memo)
                .repairPart(repairPart)
                .build();
    }
}
