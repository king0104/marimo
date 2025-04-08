package com.ssafy.marimo.card.service;

import com.ssafy.marimo.common.annotation.ExecutionTimeLog;
import com.ssafy.marimo.external.dto.FintechCardTransactionResponse;
import com.ssafy.marimo.external.fintech.FintechApiClient;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class CardTransactionService {

    private final FintechApiClient fintechApiClient;

//    @Cacheable(
//            value = "card-transactions",
//            key = "#cardNo + '-' + #cvc + '-' + #startDate + '-' + #endDate",
//            unless = "#result == null"
//    )
    @ExecutionTimeLog
    @Transactional
    public FintechCardTransactionResponse getCardTransactions(
            String cardNo, String cvc, String startDate, String endDate) {

        return fintechApiClient.getCardTransactions(cardNo, cvc, startDate, endDate);
    }
}
