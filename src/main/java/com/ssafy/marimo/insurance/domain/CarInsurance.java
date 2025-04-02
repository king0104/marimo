package com.ssafy.marimo.insurance.domain;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@Entity
@Table(name = "car_insurance")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CarInsurance extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "car_id", nullable = false)
    private Car car;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "insurance_id", nullable = false)
    private Insurance insurance;

    @Column(nullable = false)
    private LocalDateTime startDate;

    @Column(nullable = false)
    private LocalDateTime endDate;

    @Column(nullable = false)
    private LocalDateTime distanceRegistrationDate;

    @Column(nullable = false)
    private Integer registeredDistance;

    @Column(nullable = false)
    private Integer insurancePremium;

    @Builder
    private CarInsurance(Car car, Insurance insurance,
                         LocalDateTime startDate, LocalDateTime endDate,
                         LocalDateTime distanceRegistrationDate,
                         Integer registeredDistance, Integer insurancePremium) {
        this.car = car;
        this.insurance = insurance;
        this.startDate = startDate;
        this.endDate = endDate;
        this.distanceRegistrationDate = distanceRegistrationDate;
        this.registeredDistance = registeredDistance;
        this.insurancePremium = insurancePremium;
    }

    public static CarInsurance create(Car car, Insurance insurance,
                                      LocalDateTime startDate, LocalDateTime endDate,
                                      LocalDateTime distanceRegistrationDate,
                                      Integer registeredDistance, Integer insurancePremium) {
        return CarInsurance.builder()
                .car(car)
                .insurance(insurance)
                .startDate(startDate)
                .endDate(endDate)
                .distanceRegistrationDate(distanceRegistrationDate)
                .registeredDistance(registeredDistance)
                .insurancePremium(insurancePremium)
                .build();
    }

}
