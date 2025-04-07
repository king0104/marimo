import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marimo_client/providers/map/category_provider.dart';
import 'package:marimo_client/providers/map/filter.provider.dart';
import 'package:marimo_client/providers/map/location_provider.dart';
import 'package:marimo_client/providers/map/station_cards_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:marimo_client/theme.dart';
import 'package:marimo_client/utils/permission_util.dart';

import 'package:marimo_client/providers/car_provider.dart';
import 'package:marimo_client/providers/map_provider.dart';
import 'package:marimo_client/providers/navigation_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/car_payment_provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/providers/obd_analysis_provider.dart';
import 'package:marimo_client/providers/home_animation_provider.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';

import 'package:marimo_client/screens/my/MyScreen.dart';
import 'package:marimo_client/screens/map/MapScreen.dart';
import 'package:marimo_client/screens/home/HomeScreen.dart';
import 'package:marimo_client/screens/signin/SignInScreen.dart';
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';
import 'package:marimo_client/screens/signin/car/RegisterCarScreen.dart';

import 'commons/AppBar.dart';
import 'commons/BottomNavigationBar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestBluetoothPermissions();
  await dotenv.load(fileName: ".env");

  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (ex) => print("네이버 지도 인증 오류: $ex"),
  );

  // ✅ CarPaymentProvider 초기화 및 진단일 로드
  final carPaymentProvider = CarPaymentProvider();
  await carPaymentProvider.loadTireDiagnosisDate(); // ✅ 진단일 불러오기
  await carPaymentProvider.loadLastPaymentId();

  // 전역 시스템 UI 스타일 설정
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
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => StationCardsProvider()),
        ChangeNotifierProvider(create: (_) => CarPaymentProvider()),
        ChangeNotifierProvider(create: (_) => ObdPollingProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => ObdAnalysisProvider()),
        ChangeNotifierProvider(create: (_) => HomeAnimationProvider()),
        ChangeNotifierProvider(create: (_) => CarRegistrationProvider()),
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
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: brandColor,
          selectionColor: brandColor.withAlpha(80),
          selectionHandleColor: brandColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: white,
          elevation: 0,
          foregroundColor: black,
        ),
      ),
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

    return FutureBuilder<void>(
      future: () async {
        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('last_obd_data');
        print('✅ SharedPreferences 확인 결과:');
        print(stored?.substring(0, 400)); // 너무 길면 앞부분만 확인
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: brandColor)),
          );
        }

        if (!authProvider.isLoggedIn) {
          return const SignInScreen();
        } else if (!carProvider.hasAnyCar) {
          return const RegisterCarScreen();
        } else {
          return const MainScreen();
        }
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final provider = context.read<ObdPollingProvider>();
      await provider.loadResponsesFromLocal(context); // 이전 값 먼저 불러오고
    });

    _controller = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.black,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<NavigationProvider>(context);

    final screens = [
      const HomeScreen(),
      MonitoringScreen(),
      MonitoringScreen(),
      const MapScreen(),
      const MyScreen(),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(),
      body: Stack(
        children: [
          Positioned.fill(child: screens[navigationProvider.selectedIndex]),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _animation,
              child: CommonBottomNavigationBar(
                currentIndex: navigationProvider.selectedIndex,
                onTap: navigationProvider.setIndex,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
