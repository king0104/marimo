package com.ssafy.marimo.card.domain;

import com.ssafy.marimo.common.auditing.BaseTimeEntity;
import jakarta.persistence.CascadeType;
import jakarta.persistence.Column;
import jakarta.persistence.Entity;
import jakarta.persistence.FetchType;
import jakarta.persistence.GeneratedValue;
import jakarta.persistence.GenerationType;
import jakarta.persistence.Id;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import jakarta.persistence.OneToMany;
import jakarta.persistence.Table;
import java.util.ArrayList;
import java.util.List;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "card_benefit")
public class CardBenefit extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "card_id", nullable = false)
    private Card card;

    @Column(nullable = false, length = 50)
    private String category; // Ex: "GAS", "DELIVERY" etc.

    @Column(nullable = true, length = 20)
    private String unit; // Ex: "%", "원/L"

    @OneToMany(mappedBy = "cardBenefit", fetch = FetchType.LAZY, cascade = CascadeType.ALL)
    private List<CardBenefitDetail> details = new ArrayList<>();



}