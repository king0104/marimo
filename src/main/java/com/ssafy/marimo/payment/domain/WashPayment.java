package com.ssafy.marimo.payment.domain;


import com.ssafy.marimo.car.domain.Car;
import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.Filter;

@Getter
@Entity
@Table(name = "wash_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("WASH")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
@SuperBuilder
public class WashPayment extends Payment {

    @Column(nullable = true, length = 50)
    private String washType;

    public static WashPayment of(Car car, Integer price, String location, String memo, String washType) {
        return WashPayment.builder()
                .car(car)
                .price(price)
                .location(location)
                .memo(memo)
                .washType(washType)
                .build();
    }
}
