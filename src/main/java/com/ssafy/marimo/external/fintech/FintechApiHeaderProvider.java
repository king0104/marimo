package com.ssafy.marimo.external.fintech;

import java.security.SecureRandom;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class FintechApiHeaderProvider {

    @Value("${ssafy.api.key}")
    private String apiKey;

    @Value("${ssafy.user.key}")
    private String userKey;

    private static final SecureRandom random = new SecureRandom();
    private static final String CHAR_POOL = "0123456789";

    public Map<String, String> generateHeader(String apiName, String apiServiceCode) {
        LocalDateTime now = LocalDateTime.now();
        String date = now.format(DateTimeFormatter.ofPattern("yyyyMMdd"));
        String time = now.format(DateTimeFormatter.ofPattern("HHmmss"));
        String transactionId = generateTransactionId();

        Map<String, String> header = new HashMap<>();
        header.put("apiName", apiName);
        header.put("transmissionDate", date);
        header.put("transmissionTime", time);
        header.put("institutionCode", "00100");
        header.put("fintechAppNo", "001");
        header.put("apiServiceCode", apiServiceCode);
        header.put("institutionTransactionUniqueNo", transactionId);
        header.put("apiKey", apiKey);
        header.put("userKey", userKey);

        return header;
    }

    private String generateTransactionId() {
        StringBuilder sb = new StringBuilder(20);
        for (int i = 0; i < 20; i++) {
            sb.append(CHAR_POOL.charAt(random.nextInt(CHAR_POOL.length())));
        }
        return sb.toString();
    }
}
