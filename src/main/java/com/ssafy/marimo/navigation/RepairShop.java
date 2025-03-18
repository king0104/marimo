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
@Table(name = "repair_shop")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class RepairShop extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = true)
    private String name;

    @Column(nullable = true, length = 100)
    private String type;

    @Column(nullable = true)
    private String roadAddress;

    @Column(nullable = true)
    private String lotAddress;

    @Column(nullable = true)
    private Float latitude;

    @Column(nullable = true)
    private Float longitude;

    @Column(nullable = true, length = 50)
    private String status;

    @Column(nullable = true)
    private LocalDateTime closedAt;

    @Column(nullable = true)
    private LocalDateTime suspendedStartDate;

    @Column(nullable = true)
    private LocalDateTime suspendedEndDate;

    @Column(nullable = true)
    private LocalDateTime openTime;

    @Column(nullable = true)
    private LocalDateTime closeTime;

    @Column(nullable = true, length = 50)
    private String phone;

    @Column(nullable = true)
    private String agencyName;

    @Column(nullable = true, length = 50)
    private String agencyPhone;

    @Column(nullable = true)
    private LocalDateTime dataRefDate;


}
