package com.ssafy.marimo.car.domain;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
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
@Table(name = "obd2")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Obd2 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "car_id", nullable = false)
    private Car car;

    @Column(nullable = false)
    private String pid;

    @Column(nullable = false)
    private String code;

    // 정적 팩토리 메서드
    public static Obd2 create(Car car, String pid, String code) {
        return Obd2.builder()
                .car(car)
                .pid(pid)
                .code(code)
                .build();
    }

    @Builder
    private Obd2(Car car, String pid, String code) {
        this.car = car;
        this.pid = pid;
        this.code = code;
    }
}
