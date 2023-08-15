import 'package:flutter/material.dart';
import 'services/initialization_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  final InitializationService initializationService;

  const RegistrationScreen({Key? key, required this.initializationService})
      : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  String _email = '';
  String _password = '';
  String _confirmPassword = '';

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
                      Text('регистрация', style: TextStyle(fontSize: 24)),
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
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            _confirmPassword = value;
                          });
                        },
                        obscureText: !_isConfirmPasswordVisible,
                        style: TextStyle(color: Color(0xFF6F6F6F)),
                        decoration: InputDecoration(
                          labelText: 'Повторить пароль',
                          labelStyle: TextStyle(color: Color(0xFF6F6F6F)),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFF6F6F6F)),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                                _isConfirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Color(0xFF6F6F6F)),
                            onPressed: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Регистрируясь на нашей платформе, вы соглашаетесь с нашими условиями и политикой конфиденциальности.',
                        style:
                            TextStyle(fontSize: 10, color: Color(0xFF6F6F6F)),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () async {
                          if (_password == _confirmPassword) {
                            // проверка совпадения паролей
                            try {
                              User? user = await widget.initializationService
                                  .registerUser(_email, _password);
                              if (user != null) {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              } else {
                                _showErrorDialog('Ошибка',
                                    'Что-то пошло не так. Пожалуйста, попробуйте снова позже.');
                              }
                            } catch (error) {
                              handleRegistrationError(error);
                            }
                          } else {
                            _showErrorDialog('Ошибка', 'Пароли не совпадают.');
                          }
                        },
                        style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(
                              const Size(250.0, 33.0)),
                        ),
                        child: const Text('регистрация'),
                      ),
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
    if (text == 'Продолжить с Google') {
      return SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: () async {
            try {
              User? user =
                  await widget.initializationService.signInWithGoogle();
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
              User? user =
                  await widget.initializationService.signInWithFacebook();
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
              User? user = await widget.initializationService.signInWithApple();
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

  void handleRegistrationError(dynamic error) {
    String title = 'Ошибка';
    String message = 'Что-то пошло не так. Пожалуйста, попробуйте снова позже.';

    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email уже зарегистрирован.';
          break;
        case 'weak-password':
          message = 'Пароль слишком слабый.';
          break;
        case 'invalid-email':
          message = 'Неправильно отформатированный email.';
          break;
        // Можно добавить больше ошибок, если потребуется
      }
    }

    _showErrorDialog(title, message);
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
