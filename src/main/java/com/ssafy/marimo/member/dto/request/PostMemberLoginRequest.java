package com.ssafy.marimo.member.dto.request;

import jakarta.validation.constraints.NotNull;

public record PostMemberLoginRequest(
        @NotNull String email,
        @NotNull String password
) {
}
