package com.ssafy.marimo.navigation.controller;

import com.ssafy.marimo.common.annotation.ExecutionTimeLog;
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
@RequestMapping("/api/v1/maps")
@RequiredArgsConstructor
public class StationController {

    private final GasStationService gasStationService;
    private final OpinetStationSyncService opinetStationSyncService;

    @ExecutionTimeLog
    @PostMapping("/recommend/gas")
    public ResponseEntity<List<PostGasStationRecommendResponse>> getRecommendedStations(
            @Validated @RequestBody PostGasStationRecommendRequest request
    ) {

        // 필터링된 추천 주유소 3개 반환
        return ResponseEntity.ok(gasStationService.getRecommendedStations(request));
    }

    @PostMapping("/internal/sync-gas-stations")
    public ResponseEntity<Void> syncGasStations() {
        opinetStationSyncService.syncByStationName("주유소");
        return ResponseEntity.ok().build();
    }

}