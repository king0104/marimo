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
@SQLDelete(sql = "UPDATE obd2 SET deleted = true, deleted_at = NOW() WHERE id = ?")
@FilterDef(name = "deletedFilter", parameters = @ParamDef(name = "isDeleted", type = Boolean.class))
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class Obd2 {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "car_id", nullable = false)
    private Car car;

    @Column(nullable = true, length = 17)
    private String vehicle_identification_number;

    @Column(nullable = true)
    private Integer engineRpm;

    @Column(nullable = true)
    private Integer speed;

    @Column(nullable = true)
    private Float throttle_position;

    @Column(nullable = true)
    private Float massAirFlow;

    @Column(nullable = true)
    private Float intakeAirTemperature;

    @Column(nullable = true)
    private Float coolantTemperature;

    @Column(nullable = true)
    private Float fuelTotal;

    @Column(nullable = true)
    private Float fuelRemain;

    @Column(nullable = true)
    private Float oxygenSensorVoltage;

}
