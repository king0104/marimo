package com.ssafy.marimo.member.domain;

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
import org.hibernate.annotations.Filter;
import org.hibernate.annotations.FilterDef;
import org.hibernate.annotations.ParamDef;
import org.hibernate.annotations.SQLDelete;

@Getter
@Entity
@Table(name = "notification")
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@SQLDelete(sql = "UPDATE notification SET deleted = true, deleted_at = NOW() WHERE id = ?")
@Filter(name = "deletedFilter", condition = "deleted = :isDeleted")
public class Notification extends BaseTimeEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(nullable = false)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "member_id", nullable = false)
    private Member member;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private NotificationType notificationType;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String message;

    @Column(nullable = false)
    private String relatedUrl;

    @Column(nullable = false)
    private Boolean readStatus;

    @Column(nullable = false)
    private Integer relatedId;

}
