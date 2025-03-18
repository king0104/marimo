package com.ssafy.marimo.payment;

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

@Getter
@Entity
@Table(name = "oil_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("OIL")
public class OilPayment extends Payment {

    @Enumerated(EnumType.STRING)
    @Column(nullable = true, length = 50)
    private FuelType fuelType;
}
