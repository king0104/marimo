package com.ssafy.marimo.external.fintech;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.ssafy.marimo.exception.ExternalApiException;
import com.ssafy.marimo.external.dto.FintechCardListResponse;
import com.ssafy.marimo.external.dto.FintechCardTransactionResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class FintechApiClient {

    private final WebClient webClient;
    private final FintechApiHeaderProvider headerProvider;
    private final ObjectMapper objectMapper;

    public FintechCardListResponse getRegisteredCards() {
        Map<String, Object> body = new HashMap<>();
        body.put("Header", headerProvider.generateHeader(
                "inquireSignUpCreditCardList",
                "inquireSignUpCreditCardList"
        ));

        try {
            return webClient.post()
                    .uri("/ssafy/api/v1/edu/creditCard/inquireSignUpCreditCardList")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(body)
                    .retrieve()
                    .bodyToMono(FintechCardListResponse.class)
                    .block(); // 동기적으로 호출

        } catch (WebClientResponseException e) {
            try {
                Map<String, String> errorMap = objectMapper.readValue(
                        e.getResponseBodyAsString(),
                        new TypeReference<>() {}
                );
                String code = errorMap.getOrDefault("responseCode", "EXTERNAL_ERROR");
                String message = errorMap.getOrDefault("responseMessage", "외부 API 에러");

                throw new ExternalApiException(code, message, (HttpStatus) e.getStatusCode());

            } catch (JsonProcessingException parseEx) {
                throw new ExternalApiException("PARSING_ERROR", "외부 응답 파싱 실패", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }

    public FintechCardTransactionResponse getCardTransactions(String cardNo, String cvc, String startDate, String endDate) {
        Map<String, Object> body = new HashMap<>();
        body.put("Header", headerProvider.generateHeader(
                "inquireCreditCardTransactionList",
                "inquireCreditCardTransactionList"
        ));
        body.put("cardNo", cardNo);
        body.put("cvc", cvc);
        body.put("startDate", startDate);
        body.put("endDate", endDate);

        try {
            return webClient.post()
                    .uri("/ssafy/api/v1/edu/creditCard/inquireCreditCardTransactionList")
                    .contentType(MediaType.APPLICATION_JSON)
                    .bodyValue(body)
                    .retrieve()
                    .bodyToMono(FintechCardTransactionResponse.class)
                    .block();

        } catch (WebClientResponseException e) {
            try {
                Map<String, String> errorMap = objectMapper.readValue(
                        e.getResponseBodyAsString(),
                        new TypeReference<>() {}
                );
                String code = errorMap.getOrDefault("responseCode", "EXTERNAL_ERROR");
                String message = errorMap.getOrDefault("responseMessage", "외부 API 에러");

                throw new ExternalApiException(code, message, (HttpStatus) e.getStatusCode());

            } catch (JsonProcessingException parseEx) {
                throw new ExternalApiException("PARSING_ERROR", "외부 응답 파싱 실패", HttpStatus.INTERNAL_SERVER_ERROR);
            }
        }
    }


}
