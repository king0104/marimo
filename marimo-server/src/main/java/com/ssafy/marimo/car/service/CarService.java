package com.ssafy.marimo.car.service;

import com.ssafy.marimo.car.domain.Brand;
import com.ssafy.marimo.car.domain.Car;
import com.ssafy.marimo.car.dto.CarInfoDto;
import com.ssafy.marimo.car.dto.request.PatchCarRequest;
import com.ssafy.marimo.car.dto.request.PatchCarTotalDistanceRequest;
import com.ssafy.marimo.car.dto.response.GetCarResponse;
import com.ssafy.marimo.car.dto.request.PostCarRequest;
import com.ssafy.marimo.car.dto.response.PatchCarResponse;
import com.ssafy.marimo.car.dto.response.PatchCarTotalDistanceResponse;
import com.ssafy.marimo.car.dto.response.PostCarResponse;
import com.ssafy.marimo.car.repository.BrandRepository;
import com.ssafy.marimo.car.repository.CarRepository;
import com.ssafy.marimo.common.util.IdEncryptionUtil;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.NotFoundException;
import com.ssafy.marimo.member.domain.Member;
import com.ssafy.marimo.member.repository.MemberRepository;
import java.util.List;
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
                .orElseThrow(() -> new NotFoundException(ErrorStatus.MEMBER_NOT_FOUND.getErrorCode()));

        Brand brand = brandRepository.findByName(postCarRequest.brand())
                .orElseThrow(() -> new NotFoundException(ErrorStatus.BRAND_NOT_FOUND.getErrorCode()));

        Car car = Car.createInitalCar(
                member,
                postCarRequest.nickname(),
                brand,
                postCarRequest.modelName(),
                postCarRequest.plateNumber(),
                postCarRequest.vehicleIdentificationNumber(),
                postCarRequest.fuelType(),
                postCarRequest.lastCheckedDate()

        );

        Car savedCar = carRepository.save(car);

        return PostCarResponse.of(
                idEncryptionUtil.encrypt(savedCar.getId()));
    }

    public GetCarResponse getCar(Integer memberId) {
        if (!memberRepository.existsById(memberId)) {
            throw new NotFoundException(ErrorStatus.MEMBER_NOT_FOUND.getErrorCode());
        }

        List<Car> cars = carRepository.findCarsByMemberId(memberId);

        List<CarInfoDto> carInfoDtos = cars.stream()
                .map(car -> CarInfoDto.of(
                        idEncryptionUtil.encrypt(car.getId()),
                        car.getNickname(),
                        car.getBrand().getName(),
                        car.getModelName(),
                        car.getPlateNumber(),
                        car.getVehicleIdentificationNumber(),
                        car.getFuelType(),
                        car.getLastCheckedDate(),
                        car.getTireCheckedDate(),
                        car.getTotalDistance(),
                        car.getFuelEfficiency(),
                        car.getFuelLevel(),
                        car.getObd2Status(),
                        car.getLastUpdateDate()
                ))
                .toList();

        return GetCarResponse.of(carInfoDtos);
    }

    @Transactional
    public PatchCarResponse patchCar(PatchCarRequest patchCarRequest, Integer carId) {
        Car car = carRepository.findById(carId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CARD_NOT_FOUND.getErrorCode()));

        car.updateFromPatchCarRequest(patchCarRequest);

        return PatchCarResponse.of(idEncryptionUtil.encrypt(car.getId()));
    }

    @Transactional
    public PatchCarTotalDistanceResponse patchTotalDistance(PatchCarTotalDistanceRequest patchCarTotalDistanceRequest,
                                                            Integer carId) {
        Car car = carRepository.findById(carId)
                .orElseThrow(() -> new NotFoundException(ErrorStatus.CAR_NOT_FOUND.getErrorCode()));

        car.updateTotalDistance(patchCarTotalDistanceRequest.totalDistance());

        return PatchCarTotalDistanceResponse.of(idEncryptionUtil.encrypt(car.getId()));
    }

}
