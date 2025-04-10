package com.ssafy.marimo.navigation.controller;

import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.common.annotation.ExecutionTimeLog;
import com.ssafy.marimo.navigation.dto.request.GetRepairShopRequest;
import com.ssafy.marimo.navigation.dto.response.GetRepairShopResponse;
import com.ssafy.marimo.navigation.service.RepairShopService;
import jakarta.validation.constraints.NotNull;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/maps")
@RequiredArgsConstructor
public class RepairShopController {

    private final RepairShopService repairShopService;

    @ExecutionTimeLog
    @GetMapping("/recommend/repair")
    public ResponseEntity<List<GetRepairShopResponse>> getRepairShops(
            @RequestParam @NotNull Double latitude,
            @RequestParam @NotNull Double longitude,
            @CurrentMemberId Integer memberId
    ) {
        return ResponseEntity.ok(repairShopService.getRepairShops(latitude, longitude, memberId));
    }
}
