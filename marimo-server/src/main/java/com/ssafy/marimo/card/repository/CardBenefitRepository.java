package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.CardBenefit;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CardBenefitRepository extends CrudRepository<CardBenefit, Integer> {

    List<CardBenefit> findByCardIdAndCategory(Integer cardId, String category);

    @Query("SELECT cb FROM CardBenefit cb LEFT JOIN FETCH cb.details WHERE cb.card.id = :cardId AND cb.category = :category")
    List<CardBenefit> findWithDetailsByCardIdAndCategory(@Param("cardId") int cardId, @Param("category") String category);

}
