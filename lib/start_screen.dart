import 'package:flutter/material.dart';

class StartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'начать обучение',
                  style: Theme.of(context).textTheme.displayLarge,
                ),
                SizedBox(height: 20),
                Image.asset('assets/eye.png'),
                SizedBox(height: 20),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, minHeight: 40), // Уменьшаем высоту кнопки
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text('регистрация'),
                  ),
                ),
                SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(minWidth: 200, minHeight: 40), // Уменьшаем высоту кнопки
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text('войти'),
                  ),
                ),
                SizedBox(height: 30),  // Увеличиваем отступ
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/globe.png'),
                    SizedBox(width: 8),
                    Text('RU', style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(width: 8),
                    Image.asset('assets/down.png'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
