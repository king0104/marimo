package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.Card;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface CardRepository extends CrudRepository<Card, Integer> {
    Optional<Card> findByCardUniqueNo(String cardUniqueNo);
}
