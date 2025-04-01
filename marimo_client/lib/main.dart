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

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _controller;
  late Animation<Offset> _animation;

  final List<Widget> _screens = [
    HomeScreen(),
    MonitoringScreen(),
    ObdFullScanScreen(),
    MapScreen(),
    MyScreen(),
  ];

  @override
  void initState() {
    super.initState();

    // 애니메이션 초기화
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _animation = Tween<Offset>(
      begin: const Offset(0, 1), // 아래에서 시작
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // 시작 시 애니메이션 실행
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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(),
      body: Stack(
        children: [
          Positioned.fill(child: _screens[_selectedIndex]),
          // ✅ 애니메이션 추가된 BottomNavigationBar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: SlideTransition(
              position: _animation,
              child: CommonBottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
