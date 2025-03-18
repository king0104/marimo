import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';
import 'package:marimo_client/screens/monitoring/Obd2TestScreen.dart';
import 'package:marimo_client/screens/monitoring/BluetoothTestScreen.dart';
import 'package:marimo_client/screens/home/HomeScreen.dart';
import 'commons/AppBar.dart';
import 'commons/BottomNavigationBar.dart';

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
    HomeScreen(),
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
      appBar: const CommonAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: CommonBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
