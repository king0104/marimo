package com.ssafy.marimo.car.domain;

import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;
import org.hibernate.annotations.SQLDelete;

@Getter
@Entity
@Table(name = "dtc")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Dtc extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "car_id", nullable = false)
    private Car car;

    @Column(nullable = false, length = 10)
    private String code;

    @Builder
    private Dtc(Car car, String code) {
        this.car = car;
        this.code = code;
    }

    public static Dtc create(Car car, String code) {
        return Dtc.builder()
                .car(car)
                .code(code)
                .build();
    }

}
