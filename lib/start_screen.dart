import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Стартовый экран'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Добро пожаловать на стартовый экран!'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // TODO: Добавьте функциональность для кнопки "Войти"
              },
              child: Text('Войти'),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // TODO: Добавьте функциональность для кнопки "Регистрация"
              },
              child: Text('Регистрация'),
            ),
          ],
        ),
      ),
    );
  }
}
