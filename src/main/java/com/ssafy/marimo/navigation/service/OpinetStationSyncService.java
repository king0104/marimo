package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.common.annotation.ExecutionTimeLog;
import com.ssafy.marimo.navigation.domain.GasStation;
import com.ssafy.marimo.navigation.repository.GasStationRepository;
import com.ssafy.marimo.navigation.util.CoordinateConverter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.locationtech.proj4j.ProjCoordinate;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilderFactory;
import java.io.ByteArrayInputStream;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Slf4j
@Service
@RequiredArgsConstructor
public class OpinetStationSyncService {

    private final GasStationRepository gasStationRepository;
    private final RestTemplate restTemplate = new RestTemplate();

    @Value("${OPINET_KEY}")
    private String apiKey;


    public void syncByStationName(String keyword) {
        List<GasStation> basics = fetchBasicStationsByName(keyword);

        for (GasStation basic : basics) {
            gasStationRepository.findByUniId(basic.getUniId()).ifPresentOrElse(
                    existing -> log.debug("이미 존재하는 주유소: {}", existing.getUniId()),
                    () -> {
                        gasStationRepository.save(basic);
                        log.info("➕ 기본 정보 저장 완료: {}", basic.getName());
                    }
            );
        }

        List<GasStation> seoulStations = gasStationRepository.findAll().stream()
                .filter(s -> s.getAddress() != null && s.getAddress().contains("서울"))
                .toList();

        for (GasStation station : seoulStations) {
            GasStation detail = fetchStationDetail(station.getUniId());
            if (detail != null) {
                updateFrom(station, detail);
                gasStationRepository.save(station);
                log.info("✅ 서울 상세정보 동기화 완료: {}", station.getName());
            }
        }
    }

    private List<GasStation> fetchBasicStationsByName(String keyword) {
        List<GasStation> stations = new ArrayList<>();
        try {
            String url = String.format(
                    "http://www.opinet.co.kr/api/searchByName.do?code=%s&out=xml&osnm=%s",
                    apiKey, keyword
            );

            String response = restTemplate.getForObject(url, String.class);
            log.info("🔁 Opinet 응답: {}", response);

            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
                    .parse(new ByteArrayInputStream(response.getBytes(StandardCharsets.UTF_8)));

            NodeList nodeList = doc.getElementsByTagName("OIL");

            for (int i = 0; i < nodeList.getLength(); i++) {
                Element el = (Element) nodeList.item(i);

                GasStation station = GasStation.createEmpty();
                station.setUniId(getTag(el, "UNI_ID"));
                station.setName(getTag(el, "OS_NM"));
                station.setBrand(getTag(el, "POLL_DIV_CO"));
                station.setAddress(getTag(el, "VAN_ADR"));
                station.setRoadAddress(getTag(el, "NEW_ADR"));
                station.setPhone(getTag(el, "TEL"));

                double x = parseDouble(getTag(el, "GIS_X_COOR"));
                double y = parseDouble(getTag(el, "GIS_Y_COOR"));
                ProjCoordinate wgs84 = CoordinateConverter.convertTM128ToWGS84(x, y);
                station.setLongitude(wgs84.x);
                station.setLatitude(wgs84.y);

                stations.add(station);
            }

            log.info("🔍 기본 주유소 정보 수: {}", stations.size());
        } catch (Exception e) {
            log.error("❌ fetchBasicStationsByName 실패", e);
        }
        return stations;
    }
    
    @ExecutionTimeLog
    public GasStation fetchStationDetail(String uniId) {
        try {
            String url = String.format(
                    "http://www.opinet.co.kr/api/detailById.do?code=%s&id=%s&out=xml",
                    apiKey, URLEncoder.encode(uniId, StandardCharsets.UTF_8)
            );

            String response = restTemplate.getForObject(url, String.class);
            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
                    .parse(new ByteArrayInputStream(response.getBytes(StandardCharsets.UTF_8)));

            Element el = (Element) doc.getElementsByTagName("OIL").item(0);
            if (el == null) return null;

            GasStation station = GasStation.createEmpty();
            station.setName(getTag(el, "OS_NM"));
            station.setBrand(getTag(el, "POLL_DIV_CO"));
            station.setAddress(getTag(el, "VAN_ADR"));
            station.setRoadAddress(getTag(el, "NEW_ADR"));
            station.setPhone(getTag(el, "TEL"));

            double x = parseDouble(getTag(el, "GIS_X_COOR"));
            double y = parseDouble(getTag(el, "GIS_Y_COOR"));
            ProjCoordinate wgs84 = CoordinateConverter.convertTM128ToWGS84(x, y);
            station.setLongitude(wgs84.x);
            station.setLatitude(wgs84.y);

            station.setHasLpg("Y".equals(getTag(el, "LPG_YN")));
            station.setHasSelfService("Y".equals(getTag(el, "SELF_YN")));
            station.setHasMaintenance("Y".equals(getTag(el, "MAINT_YN")));
            station.setHasCarWash("Y".equals(getTag(el, "CAR_WASH_YN")));
            station.setHasCvs("Y".equals(getTag(el, "CVS_YN")));
            station.setQualityCertified("Y".equals(getTag(el, "KPETRO_YN")));

            NodeList oilPrices = el.getElementsByTagName("OIL_PRICE");
            for (int i = 0; i < oilPrices.getLength(); i++) {
                Element priceElement = (Element) oilPrices.item(i);
                String prodCd = getTag(priceElement, "PRODCD");
                Float price = parseFloat(getTag(priceElement, "PRICE"));

                switch (prodCd) {
                    case "B027" -> station.setNormalGasolinePrice(price);
                    case "B034" -> station.setPremiumGasolinePrice(price);
                    case "D047" -> station.setDieselPrice(price);
                    case "K015" -> station.setLpgPrice(price);
                    case "C004" -> station.setKerosenePrice(price);
                }
            }

            station.setStandardTime(LocalDateTime.now());
            return station;
        } catch (Exception e) {
            log.error("❌ detailById.do 실패 - uniId: {}", uniId, e);
            return null;
        }
    }

    private void updateFrom(GasStation existing, GasStation detail) {
        existing.setName(detail.getName());
        existing.setBrand(detail.getBrand());
        existing.setAddress(detail.getAddress());
        existing.setRoadAddress(detail.getRoadAddress());
        existing.setPhone(detail.getPhone());
        existing.setLatitude(detail.getLatitude());
        existing.setLongitude(detail.getLongitude());
        existing.setHasLpg(detail.getHasLpg());
        existing.setHasSelfService(detail.getHasSelfService());
        existing.setHasMaintenance(detail.getHasMaintenance());
        existing.setHasCarWash(detail.getHasCarWash());
        existing.setHasCvs(detail.getHasCvs());
        existing.setQualityCertified(detail.getQualityCertified());
        existing.setPremiumGasolinePrice(detail.getPremiumGasolinePrice());
        existing.setNormalGasolinePrice(detail.getNormalGasolinePrice());
        existing.setDieselPrice(detail.getDieselPrice());
        existing.setLpgPrice(detail.getLpgPrice());
        existing.setKerosenePrice(detail.getKerosenePrice());
        existing.setStandardTime(LocalDateTime.now());
    }

    private String getTag(Element el, String tag) {
        try {
            NodeList nodes = el.getElementsByTagName(tag);
            if (nodes.getLength() > 0) return nodes.item(0).getTextContent();
            return null;
        } catch (Exception e) {
            return null;
        }
    }

    private Double parseDouble(String value) {
        try {
            return value != null ? Double.parseDouble(value) : null;
        } catch (Exception e) {
            return null;
        }
    }

    private Float parseFloat(String value) {
        try {
            return value != null ? Float.parseFloat(value) : null;
        } catch (Exception e) {
            return null;
        }
    }
}
