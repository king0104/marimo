import 'package:marimo_client/models/map/Place.dart';

final List<Place> mockPlaces = [
  // 주유소
  Place(
    name: 'GS 칼텍스 방이점',
    type: 'gas',
    lat: 37.5153,
    lng: 127.1059,
    distance: 3.0,
    price: 1805,
    rating: 4.8,
    tags: ['24시', '셀프', '세차', '경정비', '편의점'],
  ),
  Place(
    name: '해뜨는 주유소',
    type: 'gas',
    lat: 37.5124,
    lng: 127.1023,
    distance: 4.2,
    price: 1770,
    rating: 4.5,
    tags: ['셀프', '경정비'],
  ),

  // 정비소
  Place(
    name: '현대 블루핸즈',
    type: 'repair',
    lat: 37.5139,
    lng: 127.1070,
    distance: 2.3,
    price: 0,
    rating: 4.7,
    tags: ['정기점검', '엔진오일'],
  ),
  Place(
    name: '카센타 봉천점',
    type: 'repair',
    lat: 37.5115,
    lng: 127.1091,
    distance: 3.8,
    price: 0,
    rating: 4.2,
    tags: ['브레이크', '타이어'],
  ),

  // 세차장
  Place(
    name: '스팀세차장 잠실',
    type: 'carwash',
    lat: 37.5161,
    lng: 127.1012,
    distance: 1.2,
    price: 0,
    rating: 4.9,
    tags: ['셀프세차', '외부세차', '내부세차'],
  ),
];
