package com.ssafy.marimo.card.domain;

import com.ssafy.marimo.common.auditing.BaseTimeEntity;

import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.EnumType;
import jakarta.persistence.Enumerated;
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

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "card_benefit_detail")
public class CardBenefitDetail extends BaseTimeEntity{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "card_benefit_id", nullable = false)
    private CardBenefit cardBenefit;

    @Enumerated(EnumType.STRING)
    @Column(nullable = true)
    private GasStationBrand gasStationBrand;

    @Column(nullable = false)
    private Integer discountValue;

    @Column(nullable = true, length = 20)
    private String discountUnit;

    @Column(nullable = false)
    private Boolean appliesToAllBrands;
}