// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/map_provider.dart';
import 'package:marimo_client/providers/obd_data_provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/screens/monitoring/ObdDtcScanScreen.dart';
import 'package:marimo_client/screens/monitoring/ObdFullScanScreen.dart';
import 'package:marimo_client/screens/signin/car/RegisterCarScreen.dart';
import 'package:marimo_client/utils/permission_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

// Screens
import 'package:marimo_client/screens/home/HomeScreen.dart';
import 'package:marimo_client/screens/signin/SignInScreen.dart';
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';
import 'package:marimo_client/screens/monitoring/BluetoothTestScreen.dart';
import 'package:marimo_client/screens/map/MapScreen.dart';
import 'package:marimo_client/screens/my/MyScreen.dart';

// Commons
import 'commons/AppBar.dart';
import 'commons/BottomNavigationBar.dart';

// Providersz
import 'providers/car_provider.dart';
import 'providers/car_payment_provider.dart';
import 'providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 권한 요청
  // 1. 블루투스 권한 요청
  await requestBluetoothPermissions();

  // .env 로드
  await dotenv.load(fileName: ".env");

  // 네이버 맵 초기화
  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (ex) {
      print("네이버 지도 인증 오류: $ex");
    },
  );

  // 상태바 스타일 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CarProvider()),
        ChangeNotifierProvider(create: (_) => CarRegistrationProvider()),
        ChangeNotifierProvider(create: (_) => ObdDataProvider()),
        ChangeNotifierProvider(create: (_) => CarPaymentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapStateProvider()),
        ChangeNotifierProvider(create: (_) => ObdPollingProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        // 향후 다른 Provider들도 여기에 추가 가능
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) => const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Freesentation',
        scaffoldBackgroundColor: const Color(0xFFFBFBFB),
      ),
      // 로그인 상태에 따라 시작 화면 결정: 로그인되지 않았으면 SignInScreen, 로그인되었으면 MainScreen
      home: const InitialRouter(),
    );
  }
}

class InitialRouter extends StatelessWidget {
  const InitialRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final carProvider = Provider.of<CarProvider>(context, listen: false);

    print('[DEBUG] 현재 차량 수: ${carProvider.cars.length}');

    return FutureBuilder<void>(
      future: Future.delayed(const Duration(milliseconds: 100)), // 상태 안정 대기
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (!authProvider.isLoggedIn) {
          return const SignInScreen();
        } else if (!carProvider.hasAnyCar) {
          return const RegisterCarScreen();
        } else {
          return const MainScreen();
        }

        // return const MainScreen();
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> _screens = [
    const HomeScreen(),
    MonitoringScreen(),
    const ObdFullScanScreen(),
    const MapScreen(),
    const MyScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<NavigationProvider>(
      builder: (context, navigationProvider, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFBFBFB),
          appBar: const CommonAppBar(),
          body: Stack(
            children: [
              Positioned.fill(
                child: _screens[navigationProvider.selectedIndex],
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: CommonBottomNavigationBar(
                  currentIndex: navigationProvider.selectedIndex,
                  onTap: (index) => navigationProvider.setIndex(index),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
