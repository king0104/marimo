import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';
import 'package:marimo_client/screens/monitoring/Obd2TestScreen.dart';
import 'package:marimo_client/screens/monitoring/BluetoothTestScreen.dart';

void main() {
  runApp(
    ScreenUtilInit(
      designSize: const Size(360, 800), // 📌 Figma mdpi 기준 크기
      minTextAdapt: true, // 📌 텍스트 자동 조정
      splitScreenMode: true, // 📌 가로/세로 모드 대응
      builder: (context, child) => const MyApp(),
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
        fontFamily: 'Freesentation', // 📌 전역 폰트 적용
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

  final List<Widget> _screens = [
    MonitoringScreen(),
    MonitoringScreen(),
    BluetoothTestScreen(),
    Obd2TestScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: Text("손미정", style: TextStyle(fontSize: 16.sp)),
        backgroundColor: const Color(0xFFFBFBFB),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // ✅ 고정 타입으로 설정 (배경색 유지)
        elevation: 0, // ✅ 그림자 제거
        backgroundColor: const Color(0xFFFBFBFB), // ✅ 배경색 적용
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: const Color(0xFF4888FF), // ✅ 선택된 아이콘 색상
        unselectedItemColor: Colors.grey[400], // ✅ 선택되지 않은 아이콘 색상
        showUnselectedLabels: true,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24.sp),
            label: "홈",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.monitor, size: 24.sp),
            label: "모니터링",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings, size: 24.sp),
            label: "설정",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size: 24.sp),
            label: "프로필",
          ),
        ],
        selectedLabelStyle: TextStyle(fontSize: 16.sp),
        unselectedLabelStyle: TextStyle(fontSize: 14.sp),
      ),
    );
  }
}
