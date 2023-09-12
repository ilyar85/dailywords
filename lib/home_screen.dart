import 'package:flutter/material.dart';
import 'learning_screen.dart';
import 'services/initialization_service.dart';

class HomeScreen extends StatefulWidget {
  final InitializationService initializationService;
  HomeScreen({required this.initializationService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      LearningScreen(initializationService: widget.initializationService),
      Center(child: Text("Статистика")),
      Center(child: Text("Аккаунт")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset('assets/home_inactive.png'),
            activeIcon: Image.asset('assets/home.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/statistics_inactive.png'),
            activeIcon: Image.asset('assets/statistics.png'),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/account_inactive.png'),
            activeIcon: Image.asset('assets/account.png'),
            label: '',
          ),
        ],
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

