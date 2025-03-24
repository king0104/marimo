package com.ssafy.marimo.exception;

import lombok.AccessLevel;
import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor(access = AccessLevel.PROTECTED)
public enum ErrorStatus {

    /**
     * 400 BAD_REQUEST - 비즈니스 로직 관련 에러
     */
    IO_EXCEPTION("파일 입출력 오류가 발생했습니다."),

    /**
     * 400 BAD_REQUEST - 유효성 검사 관련 에러
     */
    MISSING_REQUEST_PARAMETER("필수 요청 파라미터가 누락되었습니다."),
    METHOD_ARGUMENT_NOT_VALID("메서드 인자 유효성 검사가 실패했습니다."),
    ARGUMENT_TYPE_MISMATCH("인자 타입이 일치하지 않습니다."),
    MISSING_PATH_VARIABLE("필수 경로 변수가 누락되었습니다."),
    INVALID_ARGUMENT("잘못된 인자입니다."),
    CONSTRAINT_VIOLATION("제약 조건을 위반했습니다."),
    DATA_INTEGRITY_VIOLATION("데이터 무결성이 위반되었습니다."),
    MESSAGE_NOT_READABLE("읽을 수 없는 메시지 형식입니다."),
    INVALID_INPUT_VALUE("요청값이 올바르지 않습니다. : "),

    /**
     * 401 UNAUTHORIZED
     */


    /**
     * 403 FORBIDDEN
     */


    /**
     * 404 NOT_FOUND
     */
    CAR_NOT_FOUND("해당 차량을 찾을 수 없습니다"),
    OIL_PAYMENT_NOT_FOUND("해당 주유 차계부 내역을 찾을 수 없습니다"),
    WASH_PAYMENT_NOT_FOUND("해당 세차 차계부 내역을 찾을 수 없습니다"),
    REPAIR_PAYMENT_NOT_FOUND("해당 정비 차계부 내역을 찾을 수 없습니다"),
    /**
     * 405 METHOD_NOT_ALLOWED
     */
    METHOD_NOT_SUPPORTED("지원되지 않는 HTTP 메서드입니다."),

    /**
     * 500 SERVER_ERROR
     */
    INTERNAL_SERVER_ERROR("예상치 못한 서버 에러가 발생했습니다.");

    private final String errorCode;

}