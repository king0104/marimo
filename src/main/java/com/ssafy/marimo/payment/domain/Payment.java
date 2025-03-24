package com.ssafy.marimo.payment.domain;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorColumn;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Inheritance;
import jakarta.persistence.InheritanceType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.experimental.SuperBuilder;
import org.hibernate.annotations.Filter;

@Getter
@Entity
@Table(name = "payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Inheritance(strategy = InheritanceType.JOINED)
@DiscriminatorColumn(name = "payment_type")
public abstract class Payment extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "car_id", nullable = false)
    private Car car;

    @Column(nullable = false)
    private Integer price;

    @Column(nullable = false)
    private LocalDateTime paymentDate;

    @Column(nullable = true, length = 100)
    private String location;

    @Column(nullable = true)
    private String memo;

    protected Payment(Car car, Integer price, LocalDateTime paymentDate, String location, String memo) {
        this.car = car;
        this.price = price;
        this.paymentDate = paymentDate;
        this.location = location;
        this.memo = memo;
    }

    protected void changePayment(Integer price, LocalDateTime paymentDate, String location, String memo) {
        if (price != null) this.price = price;
        if (paymentDate != null) this.paymentDate = paymentDate;
        if (location != null) this.location = location;
        if (memo != null) this.memo = memo;
    }

}
