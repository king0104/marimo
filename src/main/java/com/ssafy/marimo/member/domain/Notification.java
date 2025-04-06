package com.ssafy.marimo.member.domain;

import com.ssafy.marimo.car.domain.Car;
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
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;
import org.hibernate.annotations.SQLDelete;

@Getter
@Entity
@Table(name = "notification")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Notification extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "car_id", nullable = false)
    private Car car;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NotificationType notificationType;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String message;

    @Column(nullable = false)
    private Boolean readStatus;

    @Column(nullable = false)
    private Integer relatedId;

    @Builder
    private Notification(Car car, NotificationType notificationType, String title,
                         String message, Boolean readStatus, Integer relatedId) {
        this.car = car;
        this.notificationType = notificationType;
        this.title = title;
        this.message = message;
        this.readStatus = readStatus;
        this.relatedId = relatedId;
    }

    public static Notification createDtcNotification(Car car, NotificationType notificationType, String title,
                                                     String message, Boolean readStatus, Integer relatedId) {
        return Notification.builder()
                .car(car)
                .notificationType(notificationType)
                .title(title)
                .message(message)
                .readStatus(readStatus)
                .relatedId(relatedId)
                .build();
    }



}
