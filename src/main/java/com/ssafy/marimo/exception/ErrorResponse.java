package com.ssafy.marimo.exception;


import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Getter;

@Getter
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ErrorResponse {

    private final String message;
    private final String detail;

    public ErrorResponse(String message) {
        this.message = message;
        this.detail = null;
    }

    public ErrorResponse(String message, String detail) {
        this.message = message;
        this.detail = detail;
    }
}