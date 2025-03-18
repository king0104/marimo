package com.ssafy.marimo.navigation;

import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;
import org.hibernate.annotations.Filter;

@Getter
@Setter
@Entity
@Table(name = "car_wash_shop")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class CarWashShop extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = true)
    private String name;

    @Column(nullable = true, length = 100)
    private String city;

    @Column(nullable = true, length = 100)
    private String district;

    @Column(nullable = true, length = 100)
    private String businessType;

    @Column(nullable = true, length = 100)
    private WashType washType;

    @Column(nullable = true)
    private String roadAddress;

    @Column(nullable = true)
    private String lotAddress;

    @Column(nullable = true, length = 100)
    private String closedDate;

    @Column(nullable = true)
    private LocalDateTime weekdayOpenTime;

    @Column(nullable = true)
    private LocalDateTime weekdayCloseTime;

    @Column(nullable = true)
    private LocalDateTime holidayOpenTime;

    @Column(nullable = true)
    private LocalDateTime holidayCloseTime;

    @Column(nullable = true, columnDefinition = "TEXT")
    private String washFeeInfo;

    @Column(nullable = true, length = 50)
    private String phoneNumber;

    @Column(nullable = true)
    private Float latitude;

    @Column(nullable = true)
    private Float longitude;

}
