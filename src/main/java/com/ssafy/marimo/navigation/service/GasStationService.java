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

    private int calcDistance(double lat1, double lng1, Double lat2, Double lng2) {
        return (int) (Math.sqrt(Math.pow(lat1 - lat2, 2) + Math.pow(lng1 - lng2, 2)) * 100000);
    }
}
