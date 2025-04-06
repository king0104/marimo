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

        // ✅ 검색 반경 처리: null → 5km, 0 → 전국
        Integer radiusKm = req.radius();
        boolean isNationwide = radiusKm != null && radiusKm == 0;
        int radiusMeter = isNationwide ? Integer.MAX_VALUE : (radiusKm != null ? radiusKm * 1000 : 5000);

        // ✅ JPA로 필터링 먼저 적용
        List<GasStation> filteredStations = gasStationRepository.findFilteredStations(
                req.hasSelfService(),
                req.hasMaintenance(),
                req.hasCarWash(),
                req.hasCvs(),
                (req.brandList() == null || req.brandList().isEmpty()) ? null : req.brandList()
        );

        return filteredStations.stream()
                .filter(s -> isValidOilType(req.oilType(), s))
                .map(s -> toRecommendResponse(s, req, radiusMeter))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(PostGasStationRecommendResponse::distance))
                .limit(3)
                .toList();
    }


    private PostGasStationRecommendResponse toRecommendResponse(GasStation s, PostGasStationRecommendRequest req, int radiusMeter) {
        double userLat = req.latitude();
        double userLng = req.longitude();
        int distance = calcDistance(userLat, userLng, s.getLatitude(), s.getLongitude());

        // ✅ 반경 기준 필터링
        if (distance > radiusMeter) return null;

        Float price = determinePriceByOilType(s, req.oilType());

        Float discountedPrice = price; // 가격 할인 로직 placeholder
        int discountAmount = 0; //
        /**
         * // ✅ 할인 정보 적용
         *         int discountAmount = cardDiscountService.getDiscountAmount(req.userId(), s.getBrand(), req.oilType());
         *         Float discountedPrice = (originalPrice != null) ? originalPrice - discountAmount : null;
         */

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
                price,
                discountedPrice,
                discountAmount,
                distance,
                req.oilType() != null ? req.oilType() : "일반 휘발유"
        );
    }

    private Float determinePriceByOilType(GasStation station, String oilType) {
        String selectedType = (oilType != null && !oilType.isBlank())
                ? oilType
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

    private boolean isValidOilType(String oilType, GasStation station) {
        if (oilType == null || oilType.isBlank()) return true;

        return switch (oilType) {
            case "고급 휘발유" -> station.getPremiumGasolinePrice() != null;
            case "일반 휘발유" -> station.getNormalGasolinePrice() != null;
            case "경유" -> station.getDieselPrice() != null;
            case "LPG" -> station.getLpgPrice() != null;
            case "등유" -> station.getKerosenePrice() != null;
            default -> false;
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