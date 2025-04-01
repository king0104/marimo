package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.navigation.domain.GasStation;
import com.ssafy.marimo.navigation.dto.request.PostGasStationRecommendRequest;
import com.ssafy.marimo.navigation.dto.response.PostGasStationRecommendResponse;
import com.ssafy.marimo.navigation.repository.GasStationRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Service
@RequiredArgsConstructor
public class GasStationService {

    private final GasStationRepository gasStationRepository;

    public void clearAllStations() {
        gasStationRepository.deleteAll();
    }

    public List<PostGasStationRecommendResponse> getRecommendedStations(PostGasStationRecommendRequest req) {
        List<GasStation> allStations = gasStationRepository.findAll();
        System.out.println("🛢️ 저장된 주유소 수: " + allStations.size());

        double userLat = req.latitude();
        double userLng = req.longitude();
        int radius = req.radius() != null ? req.radius() : 3000;

        return gasStationRepository.findAll().stream()
                .filter(s -> req.hasSelfService() == null || s.getHasSelfService().equals(req.hasSelfService()))
                .filter(s -> req.hasCVS() == null || s.getHasCvs().equals(req.hasCVS()))
                .filter(s -> req.hasCarWash() == null || s.getHasCarWash().equals(req.hasCarWash()))
                .filter(s -> req.hasMaintenance() == null || s.getHasMaintenance().equals(req.hasMaintenance()))
                .filter(s -> req.brand() == null || s.getBrand().equalsIgnoreCase(req.brand()))
                .filter(s -> s.getLatitude() != null && s.getLongitude() != null)
                .map(s -> toRecommendResponse(s, userLat, userLng, radius))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(PostGasStationRecommendResponse::distance))
                .limit(3)
                .toList();
    }

    private PostGasStationRecommendResponse toRecommendResponse(GasStation s, double userLat, double userLng, int radius) {
        int distance = calcDistance(userLat, userLng, s.getLatitude(), s.getLongitude());
        if (distance > radius) return null;

        float price = s.getNormalGasolinePrice() != null ? s.getNormalGasolinePrice() : 9999f;
        int discount = 100;

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
                false,
                price,
                price - discount,
                discount,
                distance
        );
    }

    private static final double EARTH_RADIUS = 6371e3; // 지구 반경(m 단위)

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

}
