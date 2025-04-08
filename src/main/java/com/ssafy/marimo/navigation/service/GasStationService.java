package com.ssafy.marimo.navigation.service;

import com.ssafy.marimo.card.domain.Card;
import com.ssafy.marimo.card.domain.CardBenefit;
import com.ssafy.marimo.card.domain.CardBenefitDetail;
import com.ssafy.marimo.card.domain.MemberCard;
import com.ssafy.marimo.card.repository.CardBenefitDetailRepository;
import com.ssafy.marimo.card.repository.CardBenefitRepository;
import com.ssafy.marimo.card.repository.MemberCardRepository;
import com.ssafy.marimo.card.service.CardTransactionService;
import com.ssafy.marimo.common.annotation.ExecutionTimeLog;
import com.ssafy.marimo.exception.ErrorStatus;
import com.ssafy.marimo.exception.ServerException;
import com.ssafy.marimo.external.fintech.FintechApiClient;
import com.ssafy.marimo.navigation.domain.GasStation;
import com.ssafy.marimo.navigation.dto.request.PostGasStationRecommendRequest;
import com.ssafy.marimo.navigation.dto.response.PostGasStationRecommendResponse;
import com.ssafy.marimo.navigation.repository.GasStationRepository;
import java.util.Optional;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Comparator;
import java.util.List;
import java.util.Objects;

@Slf4j
@Service
@RequiredArgsConstructor
public class GasStationService {

    private final GasStationRepository gasStationRepository;
    private final MemberCardRepository memberCardRepository;
    private final CardBenefitRepository cardBenefitRepository;
    private final CardBenefitDetailRepository cardBenefitDetailRepository;
    private final CardTransactionService cardTransactionService;

    private static final String CATEGORY_GAS = "GAS";


    @ExecutionTimeLog
    public void clearAllStations() {
        gasStationRepository.deleteAll();
    }

    public List<PostGasStationRecommendResponse> getRecommendedStations(PostGasStationRecommendRequest req, Integer memberId) {

        // ✅ 검색 반경 처리: null → 5km, 0 → 전국
        Integer radiusKm = req.radius();
        boolean isNationwide = radiusKm != null && radiusKm == 0;
        int radiusMeter = isNationwide ? Integer.MAX_VALUE : (radiusKm != null ? radiusKm * 1000 : 3000);

        log.info("📏 [검색 반경 설정] radiusKm={}, radiusMeter={}, isNationwide={}", radiusKm, radiusMeter, isNationwide);

        // ✅ JPA로 필터링 먼저 적용
        List<GasStation> filteredStations = gasStationRepository.findFilteredStations(
                req.hasSelfService(),
                req.hasMaintenance(),
                req.hasCarWash(),
                req.hasCvs(),
                (req.brandList() == null || req.brandList().isEmpty()) ? null : req.brandList()
        );

        log.info("🔍 [1차 필터링 완료] 조건에 맞는 주유소 {}개", filteredStations.size());
        // 1. 카드 등록 여부
        boolean isOilCardRegistered;
        boolean isOilCardMonthlyRequirementSatisfied;

        Optional<MemberCard> memberCard = memberCardRepository.findByMemberId(memberId);
        if (memberCard == null) {
            isOilCardMonthlyRequirementSatisfied = false;
            isOilCardRegistered = false;
            log.warn("⚠️ [카드 미등록] memberId={} 에 등록된 카드 없음", memberId);
        }

        // 2. 외부 API 사용해서 전월실적 가져오기
//        else {
//            isOilCardRegistered = true;
//            Card card = memberCard.get().getCard();
//            Integer monthlyRequirement = card.getMonthlyRequirement();
//            log.info("💳 [카드 정보] cardNo={}, monthlyRequirement={}", card.getCardNo(), monthlyRequirement);
//            Integer estimatedBalance = Integer.parseInt(
//                    cardTransactionService.getCardTransactions(card.getCardNo(), card.getCvc(),
//                            "20250401", "20250404").getRec().getEstimatedBalance());
//            // 전월 실적 기준 <= 실제 전월 실적
//            if (monthlyRequirement <= estimatedBalance) {
//                isOilCardMonthlyRequirementSatisfied = true;
//            } else {
//                isOilCardMonthlyRequirementSatisfied = false;
//            }
//        }
        else {
            isOilCardRegistered = true;
            try {
                Card card = memberCard.get().getCard();
                Integer monthlyRequirement = card.getMonthlyRequirement();
                log.info("💳 [카드 정보] cardNo={}, monthlyRequirement={}", card.getCardNo(), monthlyRequirement);

                String estimated = cardTransactionService.getCardTransactions(card.getCardNo(), card.getCvc(),
                        "20250401", "20250404").getRec().getEstimatedBalance();
                Integer estimatedBalance = Integer.parseInt(estimated);
                isOilCardMonthlyRequirementSatisfied = (monthlyRequirement <= estimatedBalance);
                log.info("📈 [실적 확인] estimatedBalance={}, 만족 여부={}", estimatedBalance, isOilCardMonthlyRequirementSatisfied);
            } catch (Exception e) {
                log.error("💥 [카드 실적 조회 실패] memberId={}, error={}", memberId, e.getMessage(), e);
                throw new ServerException(ErrorStatus.INTERNAL_SERVER_ERROR.getErrorCode());
            }
        }

        List<PostGasStationRecommendResponse> candidates = filteredStations.stream()
                .filter(s -> isValidOilType(req.oilType(), s))
                .map(s -> toRecommendResponse(s, req, radiusMeter, isOilCardRegistered, isOilCardMonthlyRequirementSatisfied, memberCard))
                .filter(Objects::nonNull)
                .sorted(Comparator.comparing(PostGasStationRecommendResponse::distance))
                .limit(5) // 가장 가까운 5개 먼저 뽑고
                .toList();

        return candidates.stream()
                .sorted(Comparator.comparing(PostGasStationRecommendResponse::discountedPrice)) // 그중 가격 낮은 순
                .toList();
    }

    @ExecutionTimeLog
    public PostGasStationRecommendResponse toRecommendResponse(GasStation s, PostGasStationRecommendRequest req, int radiusMeter, boolean isOilCardRegistered, boolean isOilCardMonthlyRequirementSatisfied, Optional<MemberCard> memberCard) {
        double userLat = req.latitude();
        double userLng = req.longitude();
        int distance = calcDistance(userLat, userLng, s.getLatitude(), s.getLongitude());

        // ✅ 반경 기준 필터링
        if (distance > radiusMeter) return null;

        Float price = determinePriceByOilType(s, req.oilType());

        float discountedPrice = price;
        float discountAmount = 0; // 현재 할인 없음

        // 카드 혜택 적용
        if (isOilCardRegistered && isOilCardMonthlyRequirementSatisfied) {
            Card card = memberCard.get().getCard(); // 이 코드 수정 필요 (null 체크 해줘야함)

            List<CardBenefit> cardBenefits = cardBenefitRepository.findByCardIdAndCategory(card.getId(), CATEGORY_GAS);
            for (CardBenefit benefit : cardBenefits) {
                List<CardBenefitDetail> cardBenefitDetails =
                        cardBenefitDetailRepository.findByCardBenefitId(benefit.getId());

                for (CardBenefitDetail cardBenefitDetail : cardBenefitDetails) {
                    // 카드 혜택 적용하기
                    if (cardBenefitDetail.getAppliesToAllBrands()) {
                        discountedPrice = applyCardBenefit(price, cardBenefitDetail.getDiscountValue(),
                                cardBenefitDetail.getDiscountUnit());
                        discountAmount = price - discountedPrice;
                        break;
                    }

                    if (cardBenefitDetail.getGasStationBrand().equals(s.getBrand())) {
                        discountedPrice = applyCardBenefit(price, cardBenefitDetail.getDiscountValue(),
                                cardBenefitDetail.getDiscountUnit());
                        discountAmount = price - discountedPrice;

                    }

                }
            }
        }else {
                log.info("ℹ️ [카드 혜택 미적용] 주유소ID={}, 등록 여부={}, 실적 만족 여부={}", s.getId(), isOilCardRegistered, isOilCardMonthlyRequirementSatisfied);

        }



        // DTO 생성
        return PostGasStationRecommendResponse.of(
                s.getId(),
                s.getName(),
                s.getBrand(),
                s.getAddress(),
                s.getRoadAddress(),
                s.getLatitude(),
                s.getLongitude(),
                s.getHasSelfService(),
                s.getHasMaintenance(),
                s.getHasCarWash(),
                s.getHasCvs(),
                price,
                discountedPrice,
                discountAmount,
                distance,
                req.oilType() != null ? req.oilType() : "일반 휘발유",
                isOilCardRegistered,
                isOilCardMonthlyRequirementSatisfied
        );
    }

    private Float determinePriceByOilType(GasStation station, String oilType) {
        String selectedType = (oilType != null && !oilType.isBlank())
                ? oilType
                : "일반 휘발유";

        return switch (selectedType) {
            case "고급 휘발유" -> station.getPremiumGasolinePrice();
            case "일반 휘발유" -> station.getNormalGasolinePrice();
            case "경유" -> station.getDieselPrice();
            case "LPG" -> station.getLpgPrice();
            case "등유" -> station.getKerosenePrice();
            default -> station.getNormalGasolinePrice();
        };
    }

    private boolean isValidOilType(String oilType, GasStation station) {
        if (oilType == null || oilType.isBlank()) return true;

        return switch (oilType) {
            case "고급 휘발유" -> station.getPremiumGasolinePrice() != null;
            case "일반 휘발유" -> station.getNormalGasolinePrice() != null;
            case "경유" -> station.getDieselPrice() != null;
            case "LPG" -> station.getLpgPrice() != null;
            case "등유" -> station.getKerosenePrice() != null;
            default -> false;
        };
    }




    private int calcDistance(double lat1, double lng1, Double lat2, Double lng2) {
        double latDistance = Math.toRadians(lat2 - lat1);
        double lngDistance = Math.toRadians(lng2 - lng1);

        double a = Math.sin(latDistance / 2) * Math.sin(latDistance / 2)
                + Math.cos(Math.toRadians(lat1)) * Math.cos(Math.toRadians(lat2))
                * Math.sin(lngDistance / 2) * Math.sin(lngDistance / 2);

        double c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));

        double distance = EARTH_RADIUS * c; // 거리(m)

        return (int) distance;
    }

    private static final double EARTH_RADIUS = 6371e3; // 지구 반경(m 단위)

    private float applyCardBenefit(float originalPrice, int discountValue, String discountUnit) {
        if ("L/원".equals(discountUnit)) {
            return originalPrice - discountValue;
        }
        else if ("%".equals(discountUnit)) {
            return (float) (originalPrice * ((100 - discountValue) / 100.0));
        }
        else {
            throw new ServerException(ErrorStatus.INTERNAL_SERVER_ERROR.getErrorCode());
        }
    }
}