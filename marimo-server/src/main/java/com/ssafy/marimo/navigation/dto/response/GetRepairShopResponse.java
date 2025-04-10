package com.ssafy.marimo.navigation.dto.response;


import lombok.Builder;

public record GetRepairShopResponse (
        Integer id,
        String name,         // 자동차정비업체명
        String type,         // 자동차정비업체종류
        String roadAddress,  // 소재지도로명주소
        String address,      // 소재지지번주소
        double latitude,     // 위도
        double longitude,    // 경도
        String status,       // 영업상태
        String openTime,     // 운영시작시각
        String closeTime,    // 운영종료시각
        String phone         // 전화번호
) {
    @Builder
    public GetRepairShopResponse {}

    public static GetRepairShopResponse create(
            Integer id,
            String name,
            String type,
            String roadAddress,
            String address,
            double latitude,
            double longitude,
            String status,
            String openTime,
            String closeTime,
            String phone
    ) {
        return GetRepairShopResponse.builder()
                .id(id)
                .name(name)
                .type(type)
                .roadAddress(roadAddress)
                .address(address)
                .latitude(latitude)
                .longitude(longitude)
                .status(status)
                .openTime(openTime)
                .closeTime(closeTime)
                .phone(phone)
                .build();
    }
}
