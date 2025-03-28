package com.ssafy.marimo.member.repository;

import com.ssafy.marimo.card.domain.MemberCard;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberCardRepository extends CrudRepository<MemberCard, Integer> {

    boolean existsByMemberIdAndCardId(Integer memberId, Integer cardId);
}
