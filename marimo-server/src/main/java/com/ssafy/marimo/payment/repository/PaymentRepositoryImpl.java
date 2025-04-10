package com.ssafy.marimo.payment.repository;

import com.querydsl.jpa.impl.JPAQueryFactory;
import com.ssafy.marimo.payment.domain.Payment;
import com.ssafy.marimo.payment.domain.QPayment;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Repository;

@Repository
@RequiredArgsConstructor
public class PaymentRepositoryImpl implements PaymentRepositoryCustom {

    private final JPAQueryFactory queryFactory;

    @Override
    public List<Payment> findByCarIdAndYearMonth(Integer carId, int year, int month) {
        QPayment payment = QPayment.payment;

        return queryFactory.selectFrom(payment)
                .where(
                        payment.car.id.eq(carId),
                        payment.paymentDate.year().eq(year),
                        payment.paymentDate.month().eq(month)
                )
                .orderBy(payment.paymentDate.desc())
                .fetch();
    }
}