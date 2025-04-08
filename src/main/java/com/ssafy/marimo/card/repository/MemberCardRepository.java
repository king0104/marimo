package com.ssafy.marimo.card.repository;

import com.ssafy.marimo.card.domain.MemberCard;
import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MemberCardRepository extends CrudRepository<MemberCard, Integer> {
    // 현재 : 테스트 유저 하나의 memberCard를 조회
    // 실제 서비스 : memberId를 사용해 해당 멤버가 등록한 memberCard를 조회
    @Query("SELECT mc FROM MemberCard mc JOIN FETCH mc.card")
    Optional<MemberCard> findByMemberId(@Param("memberId") Integer memberId);

    boolean existsByMemberIdAndCardId(Integer memberId, Integer cardId);

}
