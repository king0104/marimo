package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.navigation.domain.RepairShop;
import com.ssafy.marimo.navigation.dto.request.GetRepairShopRequest;
import com.ssafy.marimo.navigation.dto.response.GetRepairShopResponse;
import com.ssafy.marimo.navigation.repository.RepairShopRepository;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class RepairShopService {

    private final RepairShopRepository repairShopRepository;

    public List<GetRepairShopResponse> getRepairShops(GetRepairShopRequest req, Integer memberId) {
        double latitude = req.latitude();
        double longitude = req.longitude();

        Integer radiusKm = req.radius();
        int radiusMeter = (radiusKm == null) ? 5000 : (radiusKm == 0 ? Integer.MAX_VALUE : radiusKm * 1000);

        List<RepairShop> shops = repairShopRepository.findNearestRepairShops(latitude, longitude, radiusMeter);

        return shops.stream()
                .map(shop -> GetRepairShopResponse.builder()
                        .id(shop.getId())
                        .name(shop.getBusinessName())
                        .type(shop.getBusinessType())
                        .roadAddress(shop.getRoadAddress())
                        .address(shop.getJibunAddress())
                        .latitude(shop.getLatitude())
                        .longitude(shop.getLongitude())
                        .status(shop.getOperationStatus())
                        .openTime(shop.getOperationStartTime() != null ? shop.getOperationStartTime().toLocalTime().toString() : "")
                        .closeTime(shop.getOperationEndTime() != null ? shop.getOperationEndTime().toLocalTime().toString() : "")
                        .phone(shop.getPhone())
                        .build())
                .toList();
    }


}
