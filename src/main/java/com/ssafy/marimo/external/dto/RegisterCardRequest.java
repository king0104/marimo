package com.ssafy.marimo.external.dto;

public record RegisterCardRequest(
        String cardUniqueNo,
        String withdrawalAccountNo,
        String withdrawalDate
) {
}
