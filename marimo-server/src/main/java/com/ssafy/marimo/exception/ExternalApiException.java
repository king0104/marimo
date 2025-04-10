package com.ssafy.marimo.exception;

import org.springframework.http.HttpStatus;

public class ExternalApiException extends BaseException {

    public ExternalApiException(String responseCode, String responseMessage, HttpStatus status) {
        super(status, responseCode);
        super.initCause(new RuntimeException(responseMessage)); // 로그 추적용 원인 저장
    }

    public ExternalApiException(String responseCode, String responseMessage) {
        this(responseCode, responseMessage, HttpStatus.BAD_REQUEST);
    }

    @Override
    public String getMessage() {
        return getCause() != null ? getCause().getMessage() : "외부 API 예외 발생";
    }
}
