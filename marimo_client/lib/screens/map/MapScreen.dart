import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<dynamic> gasStations = [];

  @override
  void initState() {
    super.initState();
    fetchGasStations();
  }

  // ✅ [Mock 데이터] 실제 API가 없을 때 사용되는 테스트용 함수
  Future<void> fetchGasStations() async {
    await Future.delayed(const Duration(seconds: 1)); // 네트워크 지연 흉내

    final mockData = [
      {
        "name": "GS 칼텍스 방이점",
        "price": 1805,
        "distance": "3km",
        "rating": 4.8,
        "lat": 37.5153,
        "lng": 127.1059,
      },
      {
        "name": "해뜨는 주유소",
        "price": 1750,
        "distance": "0.2km",
        "rating": 4.4,
        "lat": 37.5124,
        "lng": 127.1023,
      },
    ];

    setState(() {
      gasStations = mockData;
    });
  }

  void openKakaoNavi(double lat, double lng, String name) async {
    final url =
        'kakaonavi://navigate?name=$name&x=$lng&y=$lat&coord_type=wgs84';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw '카카오내비 실행 불가';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child:
                gasStations.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : MyNaverMap(
                      addX: gasStations.first['lng'],
                      addY: gasStations.first['lat'],
                      gasStations: gasStations,
                    ),
          ),
          SizedBox(
            height: 180,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: gasStations.length,
              itemBuilder: (context, index) {
                final station = gasStations[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Container(
                      width: 250,
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            station["name"],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text("휘발유: ${station['price']}원"),
                          Text("거리: ${station['distance']}"),
                          Row(
                            children: [
                              const Icon(
                                Icons.star,
                                color: Colors.amber,
                                size: 16,
                              ),
                              Text(
                                "${station['rating']}",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),

                          const Spacer(),
                          ElevatedButton(
                            onPressed:
                                () => openKakaoNavi(
                                  station["lat"],
                                  station["lng"],
                                  station["name"],
                                ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.navigation,
                                  size: 18,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  "카카오내비",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class MyNaverMap extends StatefulWidget {
  final double addX;
  final double addY;
  final List<dynamic> gasStations;

  const MyNaverMap({
    super.key,
    required this.addX,
    required this.addY,
    required this.gasStations,
  });

  @override
  State<MyNaverMap> createState() => _MyNaverMapState();
}

class _MyNaverMapState extends State<MyNaverMap> {
  NaverMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    final cameraUpdate = NCameraUpdate.withParams(
      target: NLatLng(widget.addY, widget.addX),
      zoom: 13,
    );

    return NaverMap(
      options: NaverMapViewOptions(
        initialCameraPosition: NCameraPosition(
          target: NLatLng(widget.addY, widget.addX),
          zoom: 13,
        ),
        mapType: NMapType.basic,
      ),
      onMapReady: (controller) async {
        _mapController = controller;
        for (var station in widget.gasStations) {
          final marker = NMarker(
            id: station['name'],
            position: NLatLng(station['lat'], station['lng']),
          );
          _mapController!.addOverlay(marker);
        }
      },
    );
  }
}
