package com.ssafy.marimo.member.domain;

import com.ssafy.marimo.common.auditing.BaseTimeEntity;
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

@Entity
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Table(name = "account")
public class Account extends BaseTimeEntity{

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Column(nullable = false, length = 3)
    private String bankCode;

    @Column(nullable = false, length = 100)
    private String bankName;

    @Column(nullable = false, length = 50)
    private String userName;

    @Column(nullable = false, length = 20, unique = true)
    private String accountNo;

    @Column(nullable = false, length = 100)
    private String accountName;

    @Column(nullable = false, length = 10)
    private String accountTypeCode;

    @Column(nullable = false, length = 50)
    private String accountTypeName;

    @Column(nullable = false, length = 8)
    private String accountCreatedDate;

    @Column(nullable = false, length = 8)
    private String accountExpiryDate;

    @Column(nullable = false)
    private Long dailyTransferLimit;

    @Column(nullable = false)
    private Long oneTimeTransferLimit;

    @Column(nullable = false)
    private Long accountBalance;

    @Column(length = 8)
    private String lastTransactionDate;

    @Column(nullable = false, length = 3)
    private String currency;
}