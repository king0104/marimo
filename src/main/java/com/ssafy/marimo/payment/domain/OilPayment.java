package com.ssafy.marimo.payment.domain;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.domain.FuelType;
import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.Filter;

@Getter
@Entity
@Table(name = "oil_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("OIL")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
@SuperBuilder
public class OilPayment extends Payment {

    @Enumerated(EnumType.STRING)
    @Column(nullable = true, length = 50)
    private FuelType fuelType;

    public static OilPayment of(Car car, Integer price, String location, String memo, FuelType fuelType) {
        return OilPayment.builder()
                .car(car)
                .price(price)
                .location(location)
                .memo(memo)
                .fuelType(fuelType)
                .build();
    }
}
