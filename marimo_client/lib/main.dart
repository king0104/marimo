import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart'; // 📌 ScreenUtil 추가
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';

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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
    MonitoringScreen(),
    MonitoringScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "App Title",
          style: TextStyle(fontSize: 16.sp),
        ), // 📌 폰트 크기 자동 조정
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[900], // 📌 배경색 어둡게
        selectedItemColor: Colors.white, // 📌 선택된 아이템 색상 밝게
        unselectedItemColor: Colors.grey[400], // 📌 선택되지 않은 아이콘 색상 회색
        showUnselectedLabels: true, // 📌 선택 안 된 아이템도 텍스트 보이게 설정
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home, size: 24.sp), // 📌 아이콘 크기 조정
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
        selectedLabelStyle: TextStyle(fontSize: 12.sp), // 📌 선택된 텍스트 크기 조정
        unselectedLabelStyle: TextStyle(
          fontSize: 10.sp,
        ), // 📌 선택되지 않은 텍스트 크기 조정
      ),
    );
  }
}
