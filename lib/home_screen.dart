import 'package:flutter/material.dart';
import 'learning_screen.dart';
import 'services/initialization_service.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  int _currentIndex = 0;

  late List<Widget> _tabs;

  @override
  void initState() {
    super.initState();

    // Получаем экземпляр InitializationService через Provider
    final initializationService =
        Provider.of<InitializationService>(context, listen: false);

    _tabs = [
      LearningScreen(),
      Center(child: Text("Статистика")),
      Center(child: Text("Аккаунт")),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Navigator(
        key: _navigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
            builder: (BuildContext context) {
              return IndexedStack(
                index: _currentIndex,
                children: _tabs,
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          if (_navigatorKey.currentState!.canPop()) {
            _navigatorKey.currentState!.pop();
          }
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
