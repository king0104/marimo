package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.CardBenefitDetail;
import java.util.List;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardBenefitDetailRepository extends CrudRepository<CardBenefitDetail, Integer> {

    List<CardBenefitDetail> findByCardBenefitId(Integer cardBenefitId);
}