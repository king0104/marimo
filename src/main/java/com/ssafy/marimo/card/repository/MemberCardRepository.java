package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.MemberCard;
import java.util.Optional;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberCardRepository extends CrudRepository<MemberCard, Integer> {
    Optional<MemberCard> findByMemberId(Integer memberId);
}
