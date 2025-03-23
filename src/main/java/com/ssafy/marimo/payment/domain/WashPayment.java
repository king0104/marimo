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
@Table(name = "wash_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("WASH")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class WashPayment extends Payment {

    @Column(nullable = true, length = 50)
    private String washType;


    @Builder
    public WashPayment(Car car, Integer price, String location, String memo, String washType) {
        super(car, price, location, memo);
        this.washType = washType;
    }

    public static WashPayment create(Car car, Integer price, String location, String memo, String washType) {
        return WashPayment.builder()
                .car(car)
                .price(price)
                .location(location)
                .memo(memo)
                .washType(washType)
                .build();
    }
}
