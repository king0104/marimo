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
@Table(name = "repair_payment")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@DiscriminatorValue("REPAIR")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class RepairPayment extends Payment {

    @Column(nullable = true, length = 50)
    private String repairPart;
}
