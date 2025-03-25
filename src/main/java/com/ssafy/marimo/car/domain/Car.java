package com.ssafy.marimo.car.domain;

import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import com.ssafy.marimo.member.domain.Member;
import jakarta.persistence.*;
import lombok.*;

import java.time.LocalDateTime;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;
import org.hibernate.annotations.SQLDelete;



@Entity
@Getter
@Table(name = "car")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Car extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "brand_id", nullable = false)
    private Brand brand;

    @Column(nullable = false, length = 50)
    private String nickname;

    @Column(nullable = false, length = 100)
    private String modelName;

    @Column(nullable = false, length = 20, unique = true)
    private String plateNumber;

    @Column(nullable = false, length = 17, unique = true)
    private String vehicleIdentificationNumber;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 10)
    private FuelType fuelType;

    @Column(nullable = true)
    private LocalDateTime lastCheckedDate;

    @Column(nullable = true)
    private LocalDateTime tireCheckedDate;

    @Column(nullable = false)
    private Integer totalDistance;

    @Column(nullable = false)
    private Float fuelEfficiency;

    @Column(nullable = false)
    private Integer fuelLevel;

    @Column(nullable = true)
    private LocalDateTime lastUpdateDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private OBD2Status obd2Status;

    @Column(nullable = false)
    private Integer score;

    @Builder
    private Car(Member member,
                Brand brand,
                String nickname,
                String modelName,
                String plateNumber,
                String vehicleIdentificationNumber,
                FuelType fuelType,
                Integer totalDistance,
                Float fuelEfficiency,
                Integer fuelLevel,
                OBD2Status obd2Status) {
        this.member = member;
        this.brand = brand;
        this.nickname = nickname;
        this.modelName = modelName;
        this.plateNumber = plateNumber;
        this.vehicleIdentificationNumber = vehicleIdentificationNumber;
        this.fuelType = fuelType;
        this.totalDistance = totalDistance;
        this.fuelEfficiency = fuelEfficiency;
        this.fuelLevel = fuelLevel;
        this.obd2Status = obd2Status;
    }

    public static Car createInitalCar(
            Member member,
            String nickname,
            Brand brand,
            String modelName,
            String plateNumber,
            String vehicleIdentificationNumber,
            FuelType fuelType
    ) {
        return Car.builder()
                .member(member)
                .nickname(nickname)
                .brand(brand)
                .modelName(modelName)
                .plateNumber(plateNumber)
                .vehicleIdentificationNumber(vehicleIdentificationNumber)
                .fuelType(fuelType)
                .build();
    }

}
