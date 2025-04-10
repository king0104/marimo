package com.ssafy.marimo.navigation.repository;

import com.ssafy.marimo.navigation.domain.GasStation;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface GasStationRepository extends JpaRepository<GasStation, Integer> {

    // ✅ 기본 필터 조건 기반 검색 (브랜드, 시설 여부)
    @Query("""
        SELECT s FROM GasStation s
        WHERE (:hasSelfService IS NULL OR s.hasSelfService = :hasSelfService)
          AND (:hasMaintenance IS NULL OR s.hasMaintenance = :hasMaintenance)
          AND (:hasCarWash IS NULL OR s.hasCarWash = :hasCarWash)
          AND (:hasCvs IS NULL OR s.hasCvs = :hasCvs)
          AND (:brandList IS NULL OR s.brand IN :brandList)
    """)
    List<GasStation> findFilteredStations(
            @Param("hasSelfService") Boolean hasSelfService,
            @Param("hasMaintenance") Boolean hasMaintenance,
            @Param("hasCarWash") Boolean hasCarWash,
            @Param("hasCvs") Boolean hasCvs,
            @Param("brandList") List<String> brandList
    );

    // 중복 저장 방지용 주소 기반 조회
    Optional<GasStation> findByUniId(String uniId);
}
