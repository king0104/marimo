package com.ssafy.marimo.car.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.domain.Dtc;
import com.ssafy.marimo.car.dto.request.PostDtcRequest;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.car.repository.DtcRepository;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class DtcService {

    private final DtcRepository dtcRepository;
    private final CarRepository carRepository;

    @Transactional
    public void postDtc(PostDtcRequest postDtcRequest, Integer carId) {
        Car car = carRepository.findById(carId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        List<Dtc> savedDtcs = new ArrayList<>();
        List<String> dtcs = postDtcRequest.dtcs();
        for (String dtc : dtcs) {
            savedDtcs.add(
                    Dtc.create(car, dtc)
            );
        }

        dtcRepository.saveAll(savedDtcs);

    }
}
