package com.ssafy.marimo.navigation.repository;

import com.ssafy.marimo.navigation.domain.RepairShop;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface RepairShopRepository extends CrudRepository<RepairShop, Integer> {
    @Query(value = """
        SELECT *,
            (6371000 * acos(
                cos(radians(:latitude)) * cos(radians(latitude)) *
                cos(radians(longitude) - radians(:longitude)) +
                sin(radians(:latitude)) * sin(radians(latitude))
            )) AS distance
        FROM repair_shop
        WHERE latitude IS NOT NULL AND longitude IS NOT NULL
        HAVING distance <= :radius
        ORDER BY distance
        LIMIT 3
        """, nativeQuery = true)
    List<RepairShop> findNearestRepairShops(
            @Param("latitude") double latitude,
            @Param("longitude") double longitude,
            @Param("radius") int radius
    );
}
