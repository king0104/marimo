package com.ssafy.marimo.navigation.dto.request;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;


public record PostGasStationRecommendRequest(
        @NotNull Double latitude,
        @NotNull Double longitude,
        @Nullable Integer radius,
        // @Nullable Boolean is24Hours,
        @Nullable Boolean hasSelfService,
        @Nullable Boolean hasMaintenance,
        @Nullable Boolean hasCarWash,
        @Nullable Boolean hasCvs,
        @Nullable String brand,
        @Nullable String oilType
) {}