package com.ssafy.marimo.navigation.repository;

import com.ssafy.marimo.navigation.domain.CarWashShop;
import java.util.List;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface CarWashShopRepository extends CrudRepository<CarWashShop, Integer> {

    @Query(value = """
        SELECT *, (
            6371000 * acos(
                cos(radians(:lat)) * cos(radians(latitude)) *
                cos(radians(longitude) - radians(:lng)) +
                sin(radians(:lat)) * sin(radians(latitude))
            )
        ) AS distance
        FROM car_wash_shop
        WHERE latitude IS NOT NULL AND longitude IS NOT NULL
        ORDER BY distance
        LIMIT 3
    """, nativeQuery = true)
    List<CarWashShop> findNearestCarWashShops(
            @Param("lat") double latitude,
            @Param("lng") double longitude
    );
}
