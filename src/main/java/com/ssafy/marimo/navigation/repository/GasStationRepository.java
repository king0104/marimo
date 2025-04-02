// repository/GasStationRepository.java
package com.ssafy.marimo.navigation.repository;

import com.ssafy.marimo.navigation.domain.GasStation;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GasStationRepository extends JpaRepository<GasStation, Integer> {
    Optional<GasStation> findByNameAndAddress(String name, String address);
    Optional<GasStation> findByRoadAddress(String roadAddress);
}
