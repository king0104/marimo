package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.navigation.domain.GasStation;
import com.ssafy.marimo.navigation.dto.request.PostGasStationRecommendRequest;
import com.ssafy.marimo.navigation.dto.response.PostGasStationRecommendResponse;
import com.ssafy.marimo.navigation.repository.GasStationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public class GasStationService {

    private final GasStationRepository gasStationRepository;

    public void clearAllStations() {
        gasStationRepository.deleteAll();
    }

    public List<PostGasStationRecommendResponse> getRecommendedStations(PostGasStationRecommendRequest req) {
        return gasStationRepository.findAll().stream()
                .filter(s -> req.hasSelfService() == null || s.getHasSelfService().equals(req.hasSelfService()))
                .filter(s -> req.hasMaintenance() == null || s.getHasMaintenance().equals(req.hasMaintenance()))
                .filter(s -> req.hasCarWash() == null || s.getHasCarWash().equals(req.hasCarWash()))
                .filter(s -> req.hasCvs() == null || s.getHasCvs().equals(req.hasCvs()))
                .filter(s -> req.brandList() == null || req.brandList().isEmpty()
                        || req.brandList().contains(s.getBrand()))
                .map(s -> toRecommendResponse(s, req))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(PostGasStationRecommendResponse::distance))
                .limit(3)
                .toList();
    }


    private PostGasStationRecommendResponse toRecommendResponse(GasStation s, PostGasStationRecommendRequest req) {
        double userLat = req.latitude();
        double userLng = req.longitude();
        int distance = calcDistance(userLat, userLng, s.getLatitude(), s.getLongitude());
        if (distance > (req.radius() != null ? req.radius() : 3000)) return null;

        Float price = determinePriceByOilType(s, req.oilTypeList());

        // 가격 할인 로직은 별도로 추가하세요.
        Float discountedPrice = price; // 현재는 가격 그대로 사용
        int discountAmount = 0; // 현재 할인 없음

        // DTO 생성
        return PostGasStationRecommendResponse.of(
                s.getId(),
                s.getName(),
                s.getBrand(),
                s.getAddress(),
                s.getRoadAddress(),
                s.getLatitude(),
                s.getLongitude(),
                s.getHasSelfService(),
                s.getHasMaintenance(),
                s.getHasCarWash(),
                s.getHasCvs(),
                // false, // is24Hours 정보를 업데이트해야 할 수 있습니다.
                price,
                discountedPrice,
                discountAmount,
                distance
        );
    }

    private Float determinePriceByOilType(GasStation station, List<String> oilTypeList) {
        String selectedType = (oilTypeList != null && !oilTypeList.isEmpty())
                ? oilTypeList.get(0)
                : "일반 휘발유";

        return switch (selectedType) {
            case "고급 휘발유" -> station.getPremiumGasolinePrice();
            case "일반 휘발유" -> station.getNormalGasolinePrice();
            case "경유" -> station.getDieselPrice();
            case "LPG" -> station.getLpgPrice();
            case "등유" -> station.getKerosenePrice();
            default -> station.getNormalGasolinePrice();
        };
    }



    private int calcDistance(double lat1, double lng1, Double lat2, Double lng2) {
        double latDistance = Math.toRadians(lat2 - lat1);
        double lngDistance = Math.toRadians(lng2 - lng1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        double distance = EARTH_RADIUS * c; // 거리(m)

        return (int) distance;
    }

    private static final double EARTH_RADIUS = 6371e3; // 지구 반경(m 단위)
}