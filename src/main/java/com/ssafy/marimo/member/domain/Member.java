package com.ssafy.marimo.member.domain;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.domain.FuelType;
import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import com.ssafy.marimo.payment.domain.OilPayment;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import java.time.LocalDate;
import java.time.LocalDateTime;
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
@Table(name = "member")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@SQLDelete(sql = "UPDATE member SET deleted = true, deleted_at = NOW() WHERE id = ?")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class Member extends BaseTimeEntity {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String email;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 100)
    private String password;

    @Column(nullable = false, length = 10)
    private String oauthProvider;

    @Column(nullable = false)
    private String oauthId;

    @Column(nullable = false)
    private Integer fuelSupplyLimit;

    @Column(nullable = false)
    private Boolean termsAgreed;

    @Builder
    private Member(String email, String name, String password, String oauthProvider, String oauthId, Integer fuelSupplyLimit, Boolean termsAgreed) {
        this.email = email;
        this.name = name;
        this.password = password;
        this.oauthProvider = oauthProvider;
        this.oauthId = oauthId;
        this.fuelSupplyLimit = fuelSupplyLimit;
        this.termsAgreed = termsAgreed;
    }

    public static Member create(String email, String name, String password, String oauthProvider, String oauthId, Integer fuelSupplyLimit, Boolean termsAgreed) {
        return Member.builder()
                .email(email)
                .name(name)
                .password(password)
                .oauthProvider(oauthProvider)
                .oauthId(oauthId)
                .fuelSupplyLimit(fuelSupplyLimit)
                .termsAgreed(termsAgreed)
                .build();
    }

    public static Member create(String email, String name, String password, String oauthProvider, String oauthId, Boolean termsAgreed, Boolean deleted, LocalDateTime deletedAt) {
        return Member.builder()
                .email(email)
                .name(name)
                .password(password)
                .oauthProvider(oauthProvider)
                .oauthId(oauthId)
                .termsAgreed(termsAgreed)
                .build();
    }

}
