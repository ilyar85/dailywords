import 'package:flutter/material.dart';
import 'themes/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/initialization_service.dart';
import 'splash_screen.dart';
import 'home_screen.dart';
import 'start_screen.dart';
import 'registration_screen.dart';
import 'login_screen.dart';
import 'plans_screen.dart';
import 'packs_screen.dart';
import 'categories_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    Provider<InitializationService>(
      create: (context) => InitializationService(),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initializationService = Provider.of<InitializationService>(context, listen: false);

    return MaterialApp(
      theme: appTheme,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/start': (context) => StartScreen(),
        '/register': (context) => RegistrationScreen(),
        '/login': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
        '/plans':(context) => PlansScreen(),
        '/packs':(content) => PacksScreen(),
        '/categories':(content) => CategoriesScreen(),
      },
      home: FutureBuilder( 
        future: initializationService.initialize(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Ошибка инициализации')));
          }
          if (snapshot.connectionState == ConnectionState.done) {
            if (initializationService.isUserLoggedIn) {
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
