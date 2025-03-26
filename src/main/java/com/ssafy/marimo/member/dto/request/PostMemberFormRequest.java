package com.ssafy.marimo.member.dto.request;

import jakarta.validation.constraints.NotNull;

public record PostMemberFormRequest(
        @NotNull String email,
        @NotNull String name,
        @NotNull String password) {
}
