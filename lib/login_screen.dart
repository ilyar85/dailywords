import 'package:flutter/material.dart';
import 'services/initialization_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordVisible = false;
  bool _rememberMe = true;

  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    // Получаем экземпляр InitializationService через Provider
    final initializationService = Provider.of<InitializationService>(context);

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
                        onChanged: (value) {
                          setState(() {
                            _email = value;
                          });
                        },
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
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
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
                              style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  color: Color(0xFF6F6F6F)),
                            ),
                          ),
                          Row(
                            children: [
                              Checkbox(
                                onChanged: (bool? value) {
                                  setState(() {
                                    _rememberMe =
                                        value!; // Обновите значение _rememberMe
                                  });
                                },
                                value: _rememberMe,
                                activeColor: Color(0xFF6F6F6F),
                              ),
                              const Text(
                                'запомнить меня',
                                style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: Color(0xFF6F6F6F)),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: () async {
                            try {
                              User? user = await initializationService
                                  .loginUser(_email, _password);
                              if (user != null) {
                                // Пользователь успешно авторизовался
                                if (_rememberMe) {
                                  await initializationService
                                      .setRememberedUser(user.uid);
                                } else {
                                  await initializationService
                                      .removeRememberedUser();
                                }
                                Navigator.pushReplacementNamed(context,
                                    '/plans'); // или любой другой маршрут для авторизованных пользователей
                              } else {
                                // Ошибка авторизации (можно показать ошибку пользователю)
                              }
                            } catch (error) {
                              handleLoginError(error);
                            }
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all(const Size(
                                250.0, 33.0)), // задаём минимальный размер
                          ),
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
    // Получаем экземпляр InitializationService через Provider
    final initializationService = Provider.of<InitializationService>(context);

    if (text == 'Продолжить с Google') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              User? user = await initializationService.signInWithGoogle();
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                // Показать сообщение об ошибке
              }
            } catch (error) {
              handleLoginError(error);
            }
          },
          icon: Image.asset(iconPath, height: 20.0),
          label: Text(text),
        ),
      );
    } else if (text == 'Продолжить с Facebook') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              User? user = await initializationService.signInWithFacebook();
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                // Показать сообщение об ошибке
              }
            } catch (error) {
              handleLoginError(error);
            }
          },
          icon: Image.asset(iconPath, height: 20.0),
          label: Text(text),
        ),
      );
    } else if (text == 'Продолжить с Apple') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              User? user = await initializationService.signInWithApple();
              if (user != null) {
                Navigator.pushReplacementNamed(context, '/home');
              } else {
                // Показать сообщение об ошибке
              }
            } catch (error) {
              handleLoginError(error);
            }
          },
          icon: Image.asset(iconPath, height: 20.0),
          label: Text(text),
        ),
      );
    }
    return SizedBox.shrink();
  }

  void _showErrorDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            child: Text('Ok'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  void handleLoginError(dynamic error) {
    String title = 'Ошибка';
    String message = 'Что-то пошло не так. Пожалуйста, попробуйте снова позже.';

    switch (error.code) {
      case 'user-not-found':
        message = 'Пользователь с таким email не найден.';
        break;
      case 'wrong-password':
        message = 'Неверный пароль.';
        break;
      case 'invalid-email':
        message = 'Неправильно отформатированный email.';
        break;
      // Можно добавить больше ошибок, если потребуется
    }

    _showErrorDialog(title, message);
  }
}
