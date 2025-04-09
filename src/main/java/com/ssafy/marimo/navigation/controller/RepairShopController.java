package com.ssafy.marimo.navigation.controller;

import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.common.annotation.ExecutionTimeLog;
import com.ssafy.marimo.navigation.dto.request.GetRepairShopRequest;
import com.ssafy.marimo.navigation.dto.response.GetRepairShopResponse;
import com.ssafy.marimo.navigation.service.RepairShopService;
import java.util.List;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/maps")
@RequiredArgsConstructor
public class RepairShopController {

    private final RepairShopService repairShopService;

    @ExecutionTimeLog
    @PostMapping("/recommend/repair") // 수정 필요
    public ResponseEntity<List<GetRepairShopResponse>> getRepairShops(
            @Validated @RequestBody GetRepairShopRequest request,
            @CurrentMemberId Integer memberId
    ) {
        return ResponseEntity.ok(repairShopService.getRepairShops(request, memberId));
    }
}
