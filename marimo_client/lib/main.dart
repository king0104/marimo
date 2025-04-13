import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:marimo_client/mocks/obd_sample.dart';
import 'package:marimo_client/providers/card_provider.dart';
import 'package:marimo_client/providers/map/category_provider.dart';
import 'package:marimo_client/providers/map/filter_provider.dart';
import 'package:marimo_client/providers/map/location_provider.dart';
import 'package:marimo_client/providers/map/station_cards_provider.dart';
import 'package:provider/provider.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

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

  // final storage = FlutterSecureStorage();
  // await storage.delete(key: 'accessToken'); // ✅ accessToken 삭제
  // print('🧹 accessToken 삭제 완료!');

  await requestBluetoothPermissions();
  await dotenv.load(fileName: ".env");

  KakaoSdk.init(nativeAppKey: dotenv.env['KAKAO_NATIVE_APP_KEY']!);

  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (ex) => print("네이버 지도 인증 오류: $ex"),
  );

  final authProvider = AuthProvider();
  await authProvider.loadTokenFromStorage(); // 자동 로그인 시도
  print('🌟 AuthProvider 초기화 완료, 자동 로그인 여부: ${authProvider.isLoggedIn}');

  final carProvider = CarProvider();
  if (authProvider.isLoggedIn) {
    await carProvider.fetchCarsFromServer(
      authProvider.accessToken!,
    ); // ✅ 이걸로 변경
  }

  final carPaymentProvider = CarPaymentProvider();
  await carPaymentProvider.loadTireDiagnosisDate();
  await carPaymentProvider.loadLastPaymentId();
  // final prefs = await SharedPreferences.getInstance();
  // await prefs.clear();

  runApp(
    MultiProvider(
      providers: [
        // ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider.value(value: carProvider),
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider.value(value: carPaymentProvider),
        ChangeNotifierProvider(create: (_) => CardProvider()),
        ChangeNotifierProvider(create: (_) => FilterProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
        ChangeNotifierProvider(create: (_) => StationCardsProvider()),
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
      future: () async {}(),
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
      await provider.loadResponsesFromLocal(context);
      await provider.loadDtcCodesFromLocal();
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
