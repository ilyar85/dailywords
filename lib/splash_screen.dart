import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'services/initialization_service.dart';

class SplashScreen extends StatefulWidget {
  final InitializationService initializationService;

  const SplashScreen({Key? key, required this.initializationService}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this);
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (widget.initializationService.isUserLoggedIn) {
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
