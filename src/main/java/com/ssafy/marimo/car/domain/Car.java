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
@SQLDelete(sql = "UPDATE car SET deleted = true, deleted_at = NOW() WHERE id = ?")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
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

    @Column(nullable = false)
    private LocalDateTime lastCheckedDate;

    @Column(nullable = false)
    private LocalDateTime tireCheckedDate;

    @Column(nullable = false)
    private Integer totalDistance;

    @Column(nullable = false)
    private Float fuelEfficiency;

    @Column(nullable = false)
    private Integer fuelLevel;

    @Column(nullable = false)
    private LocalDateTime lastUpdateDate;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private OBD2Status obd2Status;

    @Column(nullable = false)
    private Integer score;

}
