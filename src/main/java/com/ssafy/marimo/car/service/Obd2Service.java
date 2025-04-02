package com.ssafy.marimo.car.service;

import com.ssafy.marimo.car.domain.Obd2;
import com.ssafy.marimo.car.dto.request.PostObd2Request;
import com.ssafy.marimo.car.repository.Obd2Repository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class Obd2Service {
    private static Obd2Repository obd2Repository;

    public void postObd2(PostObd2Request postObd2Request) {

        // 1. obd2 만들고
        // 2. 저장

        Obd2.create()

        obd2Repository.save()
    }

    // obd2 매핑 클래스 만들기 (해석 유틸 클래스 만들기)
}
