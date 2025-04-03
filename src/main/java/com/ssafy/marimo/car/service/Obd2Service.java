package com.ssafy.marimo.car.service;

import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.domain.Obd2;
import com.ssafy.marimo.car.dto.Obd2RawDataDto;
import com.ssafy.marimo.car.dto.request.PostObd2Request;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.car.repository.Obd2Repository;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import java.util.ArrayList;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class Obd2Service {
    private final Obd2Repository obd2Repository;
    private final CarRepository carRepository;

    public void postObd2(PostObd2Request postObd2Request, Integer carId) {
        Car car = carRepository.findById(carId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        List<Obd2> obd2s = new ArrayList<>();
        List<Obd2RawDataDto> obd2RawDataDtos = postObd2Request.Obd2RawDataDto();
        for (Obd2RawDataDto obd2RawDataDto : obd2RawDataDtos) {
            obd2s.add(Obd2.create(
                    car,
                    obd2RawDataDto.pid(),
                    obd2RawDataDto.code()
            ));
        }
        obd2Repository.saveAll(obd2s);
    }

    // obd2 매핑 클래스 만들기 (해석 유틸 클래스 만들기)
}
