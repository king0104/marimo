package com.ssafy.marimo.exception;

import org.springframework.http.HttpStatus;

public class ExternalServerException extends BaseException {
    public ExternalServerException(HttpStatus httpStatus) {
        super(httpStatus);
    }

    public ExternalServerException(String responseMessage) {
        super(HttpStatus.INTERNAL_SERVER_ERROR, responseMessage);
    }

}
