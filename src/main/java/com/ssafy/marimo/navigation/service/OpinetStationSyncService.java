package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.navigation.domain.GasStation;
import com.ssafy.marimo.navigation.repository.GasStationRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.w3c.dom.*;

import javax.xml.parsers.DocumentBuilderFactory;
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
        List<String> uniIds = fetchAroundUniIds(lat, lng, radius);
        log.info("🗺️ 동기화 시도할 주유소 수: {}", uniIds.size());

        int saveCount = 0;
        for (String uniId : uniIds) {
            if (gasStationRepository.findByRoadAddress(uniId).isPresent()) continue;

            GasStation station = fetchStationDetail(uniId);
            if (station != null) {
                gasStationRepository.save(station);
                saveCount++;
                log.info("✅ 저장된 주유소: {}", station.getName());
            } else {
                log.warn("⚠️ 주유소 상세정보 가져오기 실패 - uniId: {}", uniId);
            }
        }
    }

    private List<String> fetchAroundUniIds(Double lat, Double lng, Integer radius) {
        try {
            String url = String.format(
                    "http://www.opinet.co.kr/api/aroundAll.do?code=%s&x=%f&y=%f&radius=%d",
                    apiKey, lng, lat, radius
            );
            String response = restTemplate.getForObject(url, String.class);

            Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder()
                    .parse(new java.io.ByteArrayInputStream(response.getBytes(StandardCharsets.UTF_8)));
            NodeList nodeList = doc.getElementsByTagName("OIL");

            List<String> ids = new ArrayList<>();
            for (int i = 0; i < nodeList.getLength(); i++) {
                Element element = (Element) nodeList.item(i);
                String uniId = element.getElementsByTagName("uni_id").item(0).getTextContent();
                ids.add(uniId);
            }
            log.info("🛰️ 검색된 주유소 ID 개수: {}", ids.size()); // ✅ 로그 추가

            return ids;
        } catch (Exception e) {
            log.error("❌ 주유소 ID 목록 조회 실패", e);
            log.error("Failed to fetch station ids", e);
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
                    .parse(new java.io.ByteArrayInputStream(response.getBytes(StandardCharsets.UTF_8)));
            NodeList nodeList = doc.getElementsByTagName("OIL");

            if (nodeList.getLength() == 0) return null;

            Element el = (Element) nodeList.item(0);

            GasStation station = GasStation.createEmpty();
            station.setName(getTag(el, "os_nm"));
            station.setBrand(getTag(el, "poll_div_co"));
            station.setAddress(getTag(el, "addr"));
            station.setRoadAddress(getTag(el, "rd_addr"));
            station.setPhone(getTag(el, "tel"));
            station.setLatitude(parseDouble(getTag(el, "lat")));
            station.setLongitude(parseDouble(getTag(el, "lng")));
            station.setHasLpg("Y".equals(getTag(el, "lpg_yn")));
            station.setHasSelfService("Y".equals(getTag(el, "self_yn")));
            station.setHasMaintenance("Y".equals(getTag(el, "maint_yn")));
            station.setHasCarWash("Y".equals(getTag(el, "car_wash_yn")));
            station.setHasCvs("Y".equals(getTag(el, "cvntl_yn")));
            station.setQualityCertified("Y".equals(getTag(el, "prod_cd")));
            station.setPremiumGasolinePrice(getPrice(el, "b034_p"));
            station.setNormalGasolinePrice(getPrice(el, "b027_p"));
            station.setDieselPrice(getPrice(el, "d047_p"));
            station.setLpgPrice(getPrice(el, "k015_p"));
            station.setStandardTime(LocalDateTime.now());

            return station;

        } catch (Exception e) {
            log.error("Failed to fetch station detail for uniId: " + uniId, e);
            return null;
        }
    }

    private String getTag(Element el, String tag) {
        try {
            return el.getElementsByTagName(tag).item(0).getTextContent();
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

    private Float getPrice(Element el, String tag) {
        try {
            String value = getTag(el, tag);
            return (value == null || value.isEmpty()) ? null : Float.parseFloat(value);
        } catch (Exception e) {
            return null;
        }
    }
}
