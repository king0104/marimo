package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.navigation.domain.GasStation;
import com.ssafy.marimo.navigation.repository.GasStationRepository;
import com.ssafy.marimo.navigation.util.CoordinateConverter;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.locationtech.proj4j.ProjCoordinate;
import org.springframework.beans.factory.annotation.Value;
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

    public void syncNearbyStations(Double lat, Double lng, Integer radius) {
        ProjCoordinate tm128 = CoordinateConverter.convertWGS84ToTM128(lat, lng);
        List<String> uniIds = fetchAroundUniIds(tm128.x, tm128.y, radius);

        for (String uniId : uniIds) {
            if (gasStationRepository.findByRoadAddress(uniId).isPresent()) continue;

            GasStation station = fetchStationDetail(uniId);
            if (station != null) {
                gasStationRepository.save(station);
                log.info("✅ 저장된 주유소: {}", station.getName());
            } else {
                log.warn("⚠️ 주유소 상세정보 가져오기 실패 - uniId: {}", uniId);
            }
        }
    }

    // 1. 주변 주유소의 고유 ID(uni_id)를 받기 위한 메서드
    private List<String> fetchAroundUniIds(double x, double y, Integer radius) {
        try {
            String url = String.format(
                    "http://www.opinet.co.kr/api/aroundAll.do?code=%s&x=%f&y=%f&radius=%d&out=xml",
                    apiKey, x, y, radius
            );

            // XML 형태의 응답을 받음
            String response = restTemplate.getForObject(url, String.class);

            // 받은 XML 응답을 Java의 XML Document 객체로 파싱 (변환)
            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
                    .parse(new java.io.ByteArrayInputStream(response.getBytes(StandardCharsets.UTF_8)));

            // XML에서 모든 <OIL> 태그들을 가져와 NodeList 형태로 저장
            NodeList nodeList = doc.getElementsByTagName("OIL");

            // 주유소 ID를 저장할 리스트 초기화
            List<String> ids = new ArrayList<>();

            // 모든 <OIL> 요소들을 하나씩 돌면서 주유소의 uni_id를 추출함
            for (int i = 0; i < nodeList.getLength(); i++) {
                Element element = (Element) nodeList.item(i);
                String uniId = element.getElementsByTagName("UNI_ID").item(0).getTextContent();
                ids.add(uniId);
            }

            log.info("🛰️ 검색된 주유소 ID 개수: {}", ids.size());
            return ids;
        } catch (Exception e) {
            log.error("❌ 주유소 ID 목록 조회 실패", e);
            return List.of();
        }
    }

    private GasStation fetchStationDetail(String uniId) {
        try {
            String url = String.format(
                    "http://www.opinet.co.kr/api/detailById.do?code=%s&id=%s",
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

            // TM128 좌표로 응답받은 값
            double tm128X = parseDouble(getTag(el, "GIS_X_COOR"));
            double tm128Y = parseDouble(getTag(el, "GIS_Y_COOR"));

            // TM128 → WGS84로 변환한 좌표를 DB에 저장
            ProjCoordinate wgs84 = CoordinateConverter.convertTM128ToWGS84(tm128X, tm128Y);
            station.setLatitude(wgs84.y);  // 위도 (latitude)
            station.setLongitude(wgs84.x); // 경도 (longitude)


            station.setHasLpg("Y".equals(getTag(el, "LPG_YN")));
            station.setHasSelfService("Y".equals(getTag(el, "SELF_YN")));
            station.setHasMaintenance("Y".equals(getTag(el, "MAINT_YN")));
            station.setHasCarWash("Y".equals(getTag(el, "CAR_WASH_YN")));
            station.setHasCvs("Y".equals(getTag(el, "CVS_YN")));
            station.setQualityCertified("Y".equals(getTag(el, "KPETRO_YN")));

            // 연료 종류 별 가격 받기
            NodeList oilPrices = el.getElementsByTagName("OIL_PRICE");
            for (int i = 0; i < oilPrices.getLength(); i++) {
                Element priceElement = (Element) oilPrices.item(i);
                String prodCd = getTag(priceElement, "PRODCD");
                Float price = Float.parseFloat(getTag(priceElement, "PRICE"));

                switch (prodCd) {
                    case "B027":  // 일반 가솔린 (휘발유)
                        station.setNormalGasolinePrice(price);
                        break;
                    case "B034":  // 프리미엄 가솔린 (고급 휘발유)
                        station.setPremiumGasolinePrice(price);
                        break;
                    case "D047":  // 디젤 (경유)
                        station.setDieselPrice(price);
                        break;
                    case "C004":  // 실내등유 (등유)
                        station.setDieselPrice(price);
                        break;
                    case "K015":  // 자동차부탄 (LPG)
                        station.setKerosenePrice(price);
                        break;
                }
            }

            station.setStandardTime(LocalDateTime.now());

            return station;

        } catch (Exception e) {
            log.error("❌ 상세정보 조회 실패 - uniId: {}", uniId, e);
            return null;
        }
    }

    private String getTag(Element el, String tag) {
        try {
            NodeList nodes = el.getElementsByTagName(tag);
            if (nodes.getLength() > 0) {
                return nodes.item(0).getTextContent();
            }
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
}