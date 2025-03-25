// Dependencies
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/providers/obd_data_provider.dart';
import 'package:marimo_client/screens/signin/car/RegisterCarScreen.dart';
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
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  bool isLoggedIn = true; // 로그인 상태 관리 (임시)

  final List<Widget> _screens = [
    HomeScreen(),
    MonitoringScreen(),
    BluetoothTestScreen(),
    MapScreen(),
    // RegisterCarScreen(),
    MonitoringScreen(),
  ];

  Widget _getProfileScreen() {
    return isLoggedIn ? const MyScreen() : const SignInScreen();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: const CommonAppBar(),

      body: Stack(
        children: [
          Positioned.fill(
            // 본문을 화면 전체에 채움
            child:
                _selectedIndex == 4
                    ? _getProfileScreen()
                    : _screens[_selectedIndex],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0, // 📌 네비게이션 바를 화면 하단에 배치
            child: CommonBottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}
