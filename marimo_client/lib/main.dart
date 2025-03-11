import 'package:flutter/material.dart';
import 'package:marimo_client/screens/monitoring/MonitoringScreen.dart';

void main() {
  runApp(const MyApp());
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
    MonitoringScreen(), // 바꾸면 돼용
    MonitoringScreen(),
    MonitoringScreen(), // 바꾸면 돼용
    MonitoringScreen(), // 바꾸면
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("App Title")),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.grey[900], // 📌 배경색 어둡게
        selectedItemColor: Colors.white, // 📌 선택된 아이템 색상 밝게
        unselectedItemColor: Colors.grey[400], // 📌 선택되지 않은 아이콘 색상 회색
        showUnselectedLabels: true, // 선택 안 된 아이템도 텍스트 보이게 설정
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.monitor), label: "모니터링"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "설정"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "프로필"),
        ],
      ),
    );
  }
}
