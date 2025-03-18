package com.ssafy.marimo.payment;


import jakarta.persistence.Column;
import jakarta.persistence.DiscriminatorValue;
import jakarta.persistence.Entity;
import jakarta.persistence.Table;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Filter;

@Getter
@Entity
@Table(name = "wash_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("WASH")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class WashPayment extends Payment {

    @Column(nullable = true, length = 50)
    private String washType;

}
