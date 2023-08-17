import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Image.asset('assets/back.png'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text('Выбор категорий', style: TextStyle(fontSize: 24)),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Этот экран находится в разработке.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, color: Color(0xFF6F6F6F)),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Назад'),
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Color(0xFF6F6F6F)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
