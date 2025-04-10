package com.ssafy.marimo.navigation.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Getter
@Entity
@Table(name = "repair_shop")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class RepairShop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "business_name", nullable = true)
    private String businessName; // 자동차정비업체명

    @Column(name = "business_type", nullable = true)
    private String businessType; // 자동차정비업체종류

    @Column(name = "road_address", nullable = true)
    private String roadAddress; // 소재지도로명주소

    @Column(name = "jibun_address", nullable = true)
    private String jibunAddress; // 소재지지번주소

    @Column(name = "latitude", nullable = true)
    private Double latitude; // 위도

    @Column(name = "longitude", nullable = true)
    private Double longitude; // 경도

    @Column(name = "registration_date", nullable = true)
    private LocalDateTime registrationDate; // 사업등록일자

    @Column(name = "area_size", nullable = true)
    private Integer areaSize; // 면적

    @Column(name = "operation_status", nullable = true)
    private String operationStatus; // 영업상태

    @Column(name = "closure_date", nullable = true)
    private LocalDateTime closureDate; // 폐업일자

    @Column(name = "suspend_start_date", nullable = true)
    private LocalDateTime suspendStartDate; // 휴업시작일자

    @Column(name = "suspend_end_date", nullable = true)
    private LocalDateTime suspendEndDate; // 휴업종료일자

    @Column(name = "operation_start_time", nullable = true)
    private LocalDateTime operationStartTime; // 운영시작시각

    @Column(name = "operation_end_time", nullable = true)
    private LocalDateTime operationEndTime; // 운영종료시각

    @Column(name = "phone", nullable = true)
    private String phone; // 전화번호

    @Column(name = "admin_agency", nullable = true)
    private String adminAgency; // 관리기관명

    @Column(name = "admin_phone", nullable = true)
    private String adminPhone; // 관리기관전화번호

    @Column(name = "data_standard_date", nullable = true)
    private LocalDateTime dataStandardDate; // 데이터기준일자
}
