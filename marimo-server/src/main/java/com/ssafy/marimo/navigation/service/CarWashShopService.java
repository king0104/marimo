package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.navigation.domain.CarWashShop;
import com.ssafy.marimo.navigation.dto.response.GetCarWashShopResponse;
import com.ssafy.marimo.navigation.repository.CarWashShopRepository;
import java.time.LocalDateTime;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class CarWashShopService {

    private final CarWashShopRepository carWashShopRepository;

    public List<GetCarWashShopResponse> getCarWashShops(double latitude, double longitude, Integer memberId) {
        List<CarWashShop> shops = carWashShopRepository.findNearestCarWashShops(latitude, longitude);

        return shops.stream()
                .map(shop -> GetCarWashShopResponse.builder()
                        .id(shop.getId())
                        .name(shop.getBusinessName())
                        .type(shop.getCarWashType())
                        .roadAddress(shop.getRoadAddress())
                        .address(shop.getJibunAddress())
                        .latitude(shop.getLatitude())
                        .longitude(shop.getLongitude())
                        .status("운영중") // 또는 조건 처리해서 shop.getStatus() 등 사용
                        .openTime(toTimeString(shop.getWeekdayStartTime()))
                        .closeTime(toTimeString(shop.getWeekdayEndTime()))
                        .phone(shop.getPhone())
                        .build())
                .toList();
    }

    private String toTimeString(LocalDateTime time) {
        return time != null ? time.toLocalTime().toString() : "";
    }
}
