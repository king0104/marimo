package com.ssafy.marimo.navigation.controller;

import com.ssafy.marimo.navigation.dto.request.PostGasStationRecommendRequest;
import com.ssafy.marimo.navigation.dto.response.PostGasStationRecommendResponse;
import com.ssafy.marimo.navigation.service.GasStationService;
import com.ssafy.marimo.navigation.service.OpinetStationSyncService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/v1/gas-stations")
@RequiredArgsConstructor
public class GasStationController {

    private final GasStationService gasStationService;
    private final OpinetStationSyncService opinetStationSyncService;

    @PostMapping("/recommend")
    public ResponseEntity<List<PostGasStationRecommendResponse>> getRecommendedStations(
            @Validated @RequestBody PostGasStationRecommendRequest request
    ) {
        // 1. 기존 GasStation 데이터 전체 삭제
        gasStationService.clearAllStations();

        // 2. Opinet API 호출해서 DB에 주유소 동기화
        opinetStationSyncService.syncNearbyStations(
                request.latitude(),
                request.longitude(),
                request.radius() != null ? request.radius() : 3000
        );

        // 3. 필터링된 추천 주유소 3개 반환
        return ResponseEntity.ok(gasStationService.getRecommendedStations(request));
    }
}