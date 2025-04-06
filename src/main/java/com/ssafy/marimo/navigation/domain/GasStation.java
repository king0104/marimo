package com.ssafy.marimo.navigation.domain;

import jakarta.persistence.*;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import java.time.LocalDateTime;

@Getter
@Setter
@Entity
@Table(name = "gas_station")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class GasStation {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, unique = true, length = 50)
    private String uniId;

    @Column(nullable = true)
    private String name;

    @Column(nullable = true, length = 50)
    private String brand;

    @Column(nullable = true)
    private String address;

    @Column(nullable = true)
    private String roadAddress;

    @Column(nullable = true, length = 20)
    private String phone;

    @Column(nullable = true)
    private Double latitude;

    @Column(nullable = true)
    private Double longitude;

    @Column(nullable = true)
    private Boolean hasLpg;

    @Column(nullable = true)
    private Boolean hasSelfService;

    @Column(nullable = true)
    private Boolean hasMaintenance;

    @Column(nullable = true)
    private Boolean hasCarWash;

    @Column(nullable = true)
    private Boolean hasCvs;

    @Column(nullable = true)
    private Boolean qualityCertified;

    @Column(nullable = true)
    private Float premiumGasolinePrice;

    @Column(nullable = true)
    private Float normalGasolinePrice;

    @Column(nullable = true)
    private Float dieselPrice;

    @Column(nullable = true)
    private Float lpgPrice;

    @Column(nullable = true)
    private Float kerosenePrice; // 등유 (자동차부탄) 가격

    @Column(nullable = true)
    private LocalDateTime standardTime;

    // ✅ 정적 생성 메서드 추가
    public static GasStation createEmpty() {
        return new GasStation(); // 내부에서 protected 생성자 접근 가능
    }
}
