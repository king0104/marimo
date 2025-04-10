package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.MemberCard;
import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberCardRepository extends CrudRepository<MemberCard, Integer> {
    @Query("SELECT mc FROM MemberCard mc JOIN FETCH mc.card WHERE mc.member.id = :memberId")
    Optional<MemberCard> findByMemberId(@Param("memberId") Integer memberId);

    boolean existsByMemberIdAndCardId(Integer memberId, Integer cardId);

}
