package com.ssafy.marimo.insurance.dto.response;

import com.ssafy.marimo.insurance.dto.request.PostCarInsuranceRequest;
import lombok.Builder;

@Builder
public record PostCarInsuranceResponse (
        String carInsuranceId
){
    public static PostCarInsuranceResponse of(String carInsuranceId) {
        return PostCarInsuranceResponse.builder()
                .carInsuranceId(carInsuranceId)
                .build();
    }
}
