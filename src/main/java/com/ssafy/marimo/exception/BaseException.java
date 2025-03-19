package com.ssafy.marimo.exception;

import lombok.AccessLevel;
import lombok.NoArgsConstructor;
import org.springframework.http.HttpStatus;
import lombok.Getter;

@Getter
@NoArgsConstructor(access = AccessLevel.PRIVATE)
public class BaseException extends RuntimeException {

    private HttpStatus httpStatus;
    private String errorCode;

    public BaseException(HttpStatus httpStatus) {
        super();
        this.httpStatus = httpStatus;
    }

    public BaseException(HttpStatus httpStatus, String errorCode) {
        super(errorCode);
        this.httpStatus = httpStatus;
        this.errorCode = errorCode;
    }

    public int getStatusCode() {
        return this.httpStatus.value();
    }
}