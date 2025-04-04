import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/providers/car_registration_provider.dart';
import 'package:marimo_client/providers/home_animation_provider.dart';
import 'package:marimo_client/providers/member/auth_provider.dart';
import 'package:marimo_client/providers/map_provider.dart';
import 'package:marimo_client/providers/obd_data_provider.dart';
import 'package:marimo_client/providers/obd_analysis_provider.dart';
import 'package:marimo_client/providers/obd_polling_provider.dart';
import 'package:marimo_client/screens/monitoring/ObdFullScanScreen.dart';
import 'package:marimo_client/screens/signin/car/RegisterCarScreen.dart';
import 'package:marimo_client/utils/obd_tester.dart'; // 경로는 네 파일 위치에 맞게 수정
import 'package:shared_preferences/shared_preferences.dart';
import 'package:marimo_client/theme.dart';
import 'package:marimo_client/utils/permission_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';

import 'package:marimo_client/screens/home/HomeScreen.dart';
import 'package:marimo_client/screens/signin/SignInScreen.dart';
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';
import 'package:marimo_client/screens/map/MapScreen.dart';
import 'package:marimo_client/screens/my/MyScreen.dart';

import 'commons/AppBar.dart';
import 'commons/BottomNavigationBar.dart';

import 'providers/car_provider.dart';
import 'providers/car_payment_provider.dart';
import 'providers/navigation_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await requestBluetoothPermissions();
  await dotenv.load(fileName: ".env");

  await NaverMapSdk.instance.initialize(
    clientId: dotenv.env['NAVER_MAP_CLIENT_ID']!,
    onAuthFailed: (ex) => print("네이버 지도 인증 오류: $ex"),
  );

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
        ChangeNotifierProvider(create: (_) => CarRegistrationProvider()),
        ChangeNotifierProvider(create: (_) => CarPaymentProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => MapStateProvider()),
        ChangeNotifierProvider(create: (_) => ObdPollingProvider()),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(create: (_) => HomeAnimationProvider()),
        ChangeNotifierProvider(create: (_) => ObdAnalysisProvider()),
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
          cursorColor: brandColor, // 커서 색
          selectionColor: brandColor.withAlpha(80), // 선택된 배경 색
          selectionHandleColor: brandColor, // 마커 (핸들) 색
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

  // 닫아서 쓰세요.
  static const String rawObdData = '''
  PID 0100: NO RESPONSE
PID 0101: STOPPED
PID 0102: SEARCHING...
NO DATA
PID 0103: 7E80441030200
PID 0104: 7E903410421
7E803410421
PID 0105: 7E903410577
PID 0106: 7E803410684
PID 0107: 7E803410779
PID 0108: NO DATA
PID 0109: NO DATA
PID 010A: NO DATA
PID 010B: 7E803410B24
PID 010C: 7E804410C0B86
7EE04410C0B86
7E904410C0B86
PID 010D : 7E803410D00
7E903410D00
PID 010E: 7E803410E7B
PID 010F: 7E803410F3E
PID 0110: 7E804411000D3
PID 0111: 7E903411120
7E803411120
PID 0112: NO DATA
PID 0113: 7E803411303
PID 0114: NO DATA
PID 0115: 7E804411550FF
PID 0116: NO DATA
PID 0117: NO DATA
PID 0118: NO DATA
PID 0119: NO DATA
PID 011A: NO DATA
PID 011B: NO DATA
PID 011C: 7E903411C03
7E803411C1E
PID 011D: NO DATA
PID 011E: NO DATA
PID 011F: 7E904411F0227
7E804411F0227
PID 0120: 7EE06412000018001
7E906412080018001
7E8064120A01FF011
PID 0121: 7E90441210000
7E80441210000
PID 0122: NO DATA
PID 0123: 7E80441230310
PID 0124: NO DATA
PID 0125: NO DATA
PID 0126: NO DATA
PID 0127: NO DATA
PID 0128: NO DATA
PID 0129: NO DATA
PID 012A: NO DATA
PID 012B: NO DATA
PID 012C: 7E803412C00
PID 012D: 7E803412D80
PID 012E: 7E803412E48
PID 012F: 7E803412F44
PID 0130: 7EE034130F1
7E9034130F1
7E8034130F1
PID 0131: 7E904413135B4
7EE044131365C
7E804413136F8
PID 0132: 7E8044132F922
PID 0133: 7E803413363
PID 0134: 7E80641347FF77FFB
PID 0135: NO DATA
PID 0136: NO DATA
PID 0137: NO DATA
PID 0138: NO DATA
PID 0139: NO DATA
PID 013A: NO DATA
PID 013B: NO DATA
PID 013C: 7E804413C0DC3
PID 013D: NO DATA
PID 013E: NO DATA
PID 013F: NO DATA
PID 0140: 7EE06414080000000
7E9064140C0800000
7E8064140FED08C01
PID 0141: 7EE06414100040000
7E906414100040000
7E80641410007E5A5
PID 0142: 7E9044142391D
7E804414239AD
PID 0143: 7E8044143003D
PID 0144: 7E80441447FFF
PID 0145: 7E803414506
PID 0146: 7E80341463D
PID 0147: 7E80341471F
PID 0148: NO DATA
PID 0149: 7E903414900
7E803414925
PID 014A: 7E803414A12
PID 014B: NO DATA
PID 014C: 7E803414C09
PID 014D: NO DATA
PID 014E: NO DATA
PID 014F: NO DATA
PID 0150: NO DATA
PID 0151: 7E803415101
PID 0152: NO DATA
PID 0153: NO DATA
PID 0154: NO DATA
PID 0155: 7E803415580
PID 0156: 7E803415680
PID 0157: NO DATA
PID 0158: NO DATA
PID 0159: NO DATA
PID 015A: NO DATA
PID 015B: NO DATA
PID 015C: NO DATA
PID 015D: NO DATA
PID 015E: NO DATA
PID 015F: NO DATA
PID 0160: 7E806416062200001
PID 0161: NO DATA
PID 0162: 7E803416282
PID 0163: 7E8044163015E
PID 0164: NO DATA
PID 0165: NO DATA
PID 0166: NO DATA
PID 0167: 7E8054167036A5B
PID 0168: NO DATA
PID 0169: NO DATA
PID 016A: NO DATA
PID 016B: 7E807416B1014000000
PID 016C: NO DATA
PID 016D: NO DATA
PID 016E: NO DATA
PID 016F: NO DATA
PID 0170: NO DATA
PID 0171: NO DATA
PID 0172: NO DATA
PID 0173: NO DATA
PID 0174: NO DATA
PID 0175: NO DATA
PID 0176: NO DATA
PID 0177: NO DATA
PID 0178: NO DATA
PID 0179: NO DATA
PID 017A: NO DATA
PID 017B: NO DATA
PID 017C: NO DATA
PID 017D: NO DATA
PID 017E: NO DATA
PID 017F: NO DATA
PID 0180: 7E80641800004000D
PID 0181: NO DATA
PID 0182: NO DATA
PID 0183: NO DATA
PID 0184: NO DATA
PID 0185: NO DATA
PID 0186: NO DATA
PID 0187: NO DATA
PID 0188: NO DATA
PID 0189: NO DATA
PID 018A: NO DATA
PID 018B: NO DATA
PID 018C: NO DATA
PID 018D: NO DATA
PID 018E: 7E803418E81
PID 018F: NO DATA
PID 0190: NO DATA
PID 0191: NO DATA
PID 0192: NO DATA
PID 0193: NO DATA
PID 0194: NO DATA
PID 0195: NO DATA
PID 0196: NO DATA
PID 0197: NO DATA
PID 0198: NO DATA
PID 0199: NO DATA
PID 019A: NO DATA
PID 019B: NO DATA
PID 019C: NO DATA
PID 019D: 7E806419D00070007
PID 019E: 7E804419E0033
PID 019F: NO DATA
PID 01A0: 7E80641A004000000
PID 01A1: NO DATA
PID 01A2: NO DATA
PID 01A3: NO DATA
PID 01A4: NO DATA
PID 01A5: NO DATA
PID 01A6: 7E80641A600022B79
PID 01A7: NO DATA
PID 01A8: NO DATA
PID 01A9: NO DATA
PID 01AA: NO DATA
PID 01AB: NO DATA
PID 01AC: NO DATA
PID 01AD: NO DATA
PID 01AE: NO DATA
PID 01AF: NO DATA
PID 01B0: NO DATA
PID 01B1: NO DATA
PID 01B2: NO DATA
PID 01B3: NO DATA
PID 01B4: NO DATA
PID 01B5: NO DATA
PID 01B6: NO DATA
PID 01B7: NO DATA
PID 01B8: NO DATA
PID 01B9: NO DATA
PID 01BA: NO DATA
PID 01BB: NO DATA
PID 01BC: NO DATA
PID 01BD: NO DATA
PID 01BE: NO DATA
PID 01BF: NO DATA
PID 01C0: NO DATA
PID 01C1: NO DATA
PID 01C2: NO DATA
PID 01C3: NO DATA
PID 01C4: NO DATA
PID 01C5: NO DATA
PID 01C6: NO DATA
PID 01C7: NO DATA
PID 01C8: NO DATA
PID 01C9: NO DATA
PID 01CA: NO DATA
PID 01CB: NO DATA
PID 01CC: NO DATA
PID 01CD: NO DATA
PID 01CE: NO DATA
PID 01CF: NO DATA
PID 01D0: NO DATA
PID 01D1: NO DATA
PID 01D2: NO DATA
PID 01D3: NO DATA
PID 01D4: NO DATA
PID 01D5: NO DATA
PID 01D6: NO DATA
PID 01D7: NO DATA
PID 01D8: NO DATA
PID 01D9: NO DATA
PID 01DA: NO DATA
PID 01DB: NO DATA
PID 01DC: NO DATA
PID 01DD: NO DATA
PID 01DE: NO DATA
PID 01DF: NO DATA
PID 01E0: NO DATA
PID 01E1: NO DATA
PID 01E2: NO DATA
PID 01E3: NO DATA
PID 01E4: NO DATA
PID 01E5: NO DATA
PID 01E6: NO DATA
PID 01E7: NO DATA
PID 01E8: NO DATA
PID 01E9: NO DATA
PID 01EA: NO DATA
PID 01EB: NO DATA
PID 01EC: NO DATA
PID 01ED: NO DATA
PID 01EE: NO DATA
PID 01EF: NO DATA
PID 01F0: NO DATA
PID 01F1: NO DATA
PID 01F2: NO DATA
PID 01F3: NO DATA
PID 01F4: NO DATA
PID 01F5: NO DATA
PID 01F6: NO DATA
PID 01F7: NO DATA
PID 01F8: NO DATA
PID 01F9: NO DATA
PID 01FA: NO DATA
PID 01FB: NO DATA
PID 01FC: NO DATA
PID 01FD: NO DATA
PID 01FE: NO DATA
PID 01FF: NO DATA
  ''';

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final carProvider = Provider.of<CarProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: () async {
        await saveRawObdTextToLocal(InitialRouter.rawObdData);
        print('✅ OBD 텍스트 저장 완료!');
        // 👉 저장 직후 SharedPreferences에서 값 바로 불러와 보기
        final prefs = await SharedPreferences.getInstance();
        final stored = prefs.getString('last_obd_data');
        print('✅ SharedPreferences 확인 결과:');
        print(stored?.substring(0, 400)); // 너무 길면 앞부분만 확인
        Future.delayed(const Duration(milliseconds: 100));
      }(),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // if (!authProvider.isLoggedIn) {
        //   return const SignInScreen();
        // } else if (!carProvider.hasAnyCar) {
        //   return const RegisterCarScreen();
        // } else {
          return const MainScreen();
        // }
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
      await provider.loadResponsesFromLocal(); // 이전 값 먼저 불러오고
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
