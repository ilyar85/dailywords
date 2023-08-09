import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

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
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text('вход', style: TextStyle(fontSize: 24)),
                      TextField(
                        style: TextStyle(color: Color(0xFF6F6F6F)),
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Color(0xFF6F6F6F)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                          ),
                        ),
                      ),
                      TextField(
                        obscureText: !_isPasswordVisible,
                        style: TextStyle(color: Color(0xFF6F6F6F)),
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          labelStyle: TextStyle(color: Color(0xFF6F6F6F)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFF6F6F6F)),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment
                            .spaceBetween, // Разместим элементы по обеим сторонам строки
                        children: [
                          TextButton(
                            onPressed: () {
                              // TODO: Обработка нажатия на "забыл пароль?"
                            },
                            child: const Text(
                              'забыл пароль?',
                              style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFF6F6F6F)),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                onChanged: (bool? value) {
                                  setState(() {
                                    _rememberMe = value!; // Обновите значение _rememberMe
                                  });
                                },
                                value: _rememberMe,
                                activeColor: Color(0xFF6F6F6F),
                              ),
                              const Text(
                                'запомнить меня',
                                style: TextStyle(fontWeight: FontWeight.normal, color: Color(0xFF6F6F6F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(
                                const Size(250.0, 33.0)), // задаём минимальный размер
                          ),
                          onPressed: () {},
                          child: const Text('войти')),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildSocialButton(
                  'assets/Facebook.png', 'Продолжить с Facebook'),
              const SizedBox(height: 10),
              _buildSocialButton('assets/Apple.png', 'Продолжить с Apple'),
              const SizedBox(height: 10),
              _buildSocialButton('assets/Google.png', 'Продолжить с Google'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton(String iconPath, String text) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Image.asset(iconPath,
            height: 20.0), // you can adjust the size as needed
        label: Text(text),
      ),
    );
  }
}
