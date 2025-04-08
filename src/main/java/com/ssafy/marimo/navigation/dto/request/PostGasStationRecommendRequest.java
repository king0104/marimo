package com.ssafy.marimo.navigation.dto.request;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;

import java.util.List;


public record PostGasStationRecommendRequest(
        @NotNull Double latitude,
        @NotNull Double longitude,
        @Nullable Integer radius, // 검색 반경 (단위: km) null → 기본값 5k, 0 → 전국 (거리 제한 없음)
        // @Nullable Boolean is24Hours,
        @Nullable Boolean hasSelfService,
        @Nullable Boolean hasMaintenance,
        @Nullable Boolean hasCarWash,
        @Nullable Boolean hasCvs,
        @Nullable List<String> brandList,
        @Nullable String oilType
) {}