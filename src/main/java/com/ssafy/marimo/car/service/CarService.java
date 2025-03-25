package com.ssafy.marimo.car.service;

import com.ssafy.marimo.car.domain.Brand;
import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.dto.PostCarRequest;
import com.ssafy.marimo.car.dto.PostCarResponse;
import com.ssafy.marimo.car.repository.BrandRepository;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.member.domain.Member;
import com.ssafy.marimo.member.repository.MemberRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
public class CarService {
    private final CarRepository carRepository;
    private final BrandRepository brandRepository;
    private final MemberRepository memberRepository;
    private final IdEncryptionUtil idEncryptionUtil;

    @Transactional
    public PostCarResponse postCar(PostCarRequest postCarRequest, Integer memberId) {

        Member member = memberRepository.findById(memberId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.BRAND_NOT_FOUND.getErrorCode()));

        Brand brand = brandRepository.findByName(postCarRequest.brand())
                .orElseThrow(() -> new NotFoundException(ErrorStatus.BRAND_NOT_FOUND.getErrorCode()));

        Car car = Car.createInitalCar(
                member,
                postCarRequest.nickname(),
                brand,
                postCarRequest.modelName(),
                postCarRequest.plateNumber(),
                postCarRequest.vehicleIdentificationNumber(),
                postCarRequest.fuelType()
        );

        Car savedCar = carRepository.save(car);

        return PostCarResponse.of(
                idEncryptionUtil.encrypt(savedCar.getId()));
    }
}
