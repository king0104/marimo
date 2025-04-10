package com.ssafy.marimo.navigation.dto.request;

import jakarta.annotation.Nullable;
import jakarta.validation.constraints.NotNull;

public record GetRepairShopRequest(
        @NotNull Double latitude,
        @NotNull Double longitude
) {
}
