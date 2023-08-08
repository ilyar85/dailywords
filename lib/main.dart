import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/initialization_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MainApp());
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  final InitializationService _initializationService = InitializationService();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: appTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/start': (context) => StartScreen(),
        // TODO: Добавьте другие маршруты здесь
      },
      home: FutureBuilder(
        future: _initializationService.initialize(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Ошибка инициализации')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (_initializationService.isUserLoggedIn) {
              // TODO: Возвращаем домашний экран для авторизованных пользователей
              return HomeScreen();
            } else {
              return StartScreen();
            }
          }
          return SplashScreen();
        },
      ),
    );
  }
}
