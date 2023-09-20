import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'services/initialization_service.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        final initializationService = Provider.of<InitializationService>(context, listen: false);
        await initializationService.initialize();
        if (initializationService.isUserLoggedIn) {
          Navigator.pushReplacementNamed(context, '/plans'); // или любой другой маршрут для авторизованных пользователей
        } else {
          Navigator.pushReplacementNamed(context, '/start');
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Lottie.asset(
          'assets/animations/DW_logo.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller.duration = composition.duration;
            _controller.forward();
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
