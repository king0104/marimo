package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.CardBenefit;
import java.util.List;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardBenefitRepository extends CrudRepository<CardBenefit, Integer> {
    List<CardBenefit> findByCardIdAndCategory(Integer cardId, String category);
}
