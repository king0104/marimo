package com.ssafy.marimo.navigation.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.time.LocalDateTime;

@Getter
@Entity
@Table(name = "car_wash_shop")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class CarWashShop {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "business_name")
    private String businessName; // 사업장명

    @Column(name = "sido")
    private String sido; // 시도명

    @Column(name = "sigungu")
    private String sigungu; // 시군구명

    @Column(name = "business_type")
    private String businessType; // 사업장업종명

    @Column(name = "car_wash_type")
    private String carWashType; // 세차유형

    @Column(name = "road_address")
    private String roadAddress; // 소재지도로명주소

    @Column(name = "jibun_address")
    private String jibunAddress; // 소재지지번주소

    @Column(name = "day_off")
    private String dayOff; // 휴무일

    @Column(name = "weekday_start_time")
    private LocalDateTime weekdayStartTime; // 평일운영시작시각

    @Column(name = "weekday_end_time")
    private LocalDateTime weekdayEndTime; // 평일운영종료시각

    @Column(name = "holiday_start_time")
    private LocalDateTime holidayStartTime; // 휴일운영시작시각

    @Column(name = "holiday_end_time")
    private LocalDateTime holidayEndTime; // 휴일운영종료시각

    @Column(name = "price_info")
    private String priceInfo; // 세차요금정보

    @Column(name = "owner_name")
    private String ownerName; // 대표자명

    @Column(name = "phone")
    private String phone; // 세차장전화번호

    @Column(name = "water_license_number")
    private String waterLicenseNumber; // 수질허가번호

    @Column(name = "latitude")
    private Double latitude; // WGS84 위도

    @Column(name = "longitude")
    private Double longitude; // WGS84 경도

    @Column(name = "data_standard_date")
    private LocalDateTime dataStandardDate; // 데이터기준일자
}
