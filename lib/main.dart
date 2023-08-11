import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/initialization_service.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'start_screen.dart';
import 'registration_screen.dart';
import 'login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final initializationService = InitializationService();
  runApp(MainApp(initializationService: initializationService));
}

class MainApp extends StatefulWidget {
  final InitializationService initializationService;

  MainApp({required this.initializationService});

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
        '/splash': (context) => SplashScreen(initializationService: widget.initializationService),
        '/start': (context) => StartScreen(),
        '/register': (context) => RegistrationScreen(), // предполагаемое имя для экрана регистрации
        '/login': (context) => LoginScreen(initializationService: widget.initializationService), // предполагаемое имя для экрана входа
        // TODO: Добавьте другие маршруты здесь
      },
      home: FutureBuilder(
        future: widget.initializationService.initialize(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Ошибка инициализации')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (widget.initializationService.isUserLoggedIn) {
              // TODO: Возвращаем домашний экран для авторизованных пользователей
              return HomeScreen();
            } else {
              return StartScreen();
            }
          }
          return SplashScreen(initializationService: widget.initializationService);
        },
      ),
    );
  }
}
