package com.ssafy.marimo.card.controller;

import com.ssafy.marimo.card.dto.PostCardRequest;
import com.ssafy.marimo.card.dto.PostCardResponse;
import com.ssafy.marimo.card.service.CardService;
import com.ssafy.marimo.common.annotation.CurrentMemberId;
import com.ssafy.marimo.external.dto.GetCardsWithBenefitResponse;
import com.ssafy.marimo.external.fintech.FintechApiClient;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/v1/cards")
@RequiredArgsConstructor
public class CardController {

    private final CardService cardService;

    @PostMapping("/oil/me")
    public ResponseEntity<PostCardResponse> postOilCard(@Valid @RequestBody PostCardRequest postCardRequest, @CurrentMemberId Integer memberId) {
        PostCardResponse postCardResponse = cardService.postOilCard(postCardRequest, memberId);

        return ResponseEntity.status(HttpStatus.CREATED)
                .body(postCardResponse);
    }

    @GetMapping
    public ResponseEntity<GetCardsWithBenefitResponse> getMyCardsWithBenefit() {
        GetCardsWithBenefitResponse getCardsWithBenefitResponse = cardService.getCardsWithBenefit();

        return ResponseEntity.status(HttpStatus.OK)
                .body(getCardsWithBenefitResponse);
    }


}
