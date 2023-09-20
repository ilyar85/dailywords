import 'package:flutter/material.dart';
import 'services/initialization_service.dart';
import 'package:provider/provider.dart';

class PlansScreen extends StatefulWidget {
  @override
  _PlansScreenState createState() => _PlansScreenState();
}

class _PlansScreenState extends State<PlansScreen> {
  bool _isFreeVersionSelected = true; // По умолчанию выбрана бесплатная версия

  @override
  Widget build(BuildContext context) {
    final initializationService = Provider.of<InitializationService>(context, listen: false);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 32.0, horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('выберите свой план',
                          style: TextStyle(fontSize: 41)),
                      SizedBox(height: 8),
                      Text(
                        'Платный пакет открывает больше категорий, увеличенное количество слов.',
                        style:
                            TextStyle(color: Color(0xFF6F6F6F), fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildPlanOption(
                title: 'бесплатная версия',
                description:
                    'Вы получаете 3х-дневный пробный период, который дает вам полный доступ ко всем категориям и возможность проходить тесты для заработка очков. После истечения пробного периода доступ останется только к одной бесплатной категории "MIX". Присутствует реклама.',
                isSelected: _isFreeVersionSelected,
                onTap: () {
                  setState(() {
                    _isFreeVersionSelected = true;
                  });
                },
              ),
              SizedBox(height: 10),
              _buildPlanOption(
                title: '\$4.99 все категории',
                description:
                    'Вам будут доступны все категории, а также ежемесячные бонусы, включающие новые категории MIX Plus с дополнительным набором слов за заработанные очки. Отсутствует реклама. Если вам не нужны все категории в одной покупке, вы можете приобретать отдельные категории по цене \$0.99 каждая.',
                isSelected: !_isFreeVersionSelected,
                onTap: () {
                  setState(() {
                    _isFreeVersionSelected = false;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _onContinue,
                  child: Text('продолжить'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF6F6F6F)),
                    minimumSize: MaterialStateProperty.all(Size(300, 50)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(38), // Закругление углов в 38
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanOption({
    required String title,
    required String description,
    required bool isSelected,
    required Function onTap,
  }) {
    return InkWell(
      onTap: () => onTap(),
      child: Container(
        decoration: BoxDecoration(
          color: Color(0xFF151515),
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                color: isSelected ? Color(0xFF003AFF) : Color(0xFF6F6F6F),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                color: isSelected ? Colors.white : Color(0xFF6F6F6F),
                fontSize: 10,
                fontWeight: FontWeight.w400,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onContinue() async {
    final initializationService = Provider.of<InitializationService>(context, listen: false);
    String selectedPlan = _isFreeVersionSelected ? "free" : "paid";
    await initializationService.setStudyPlan(selectedPlan);

    // Отображение информационного сообщения
    final snackBar = SnackBar(
      content: Text(
          'Поздравляем с выбором ${_isFreeVersionSelected ? "бесплатной версии" : "платного пакета"}!'),
      duration: Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // Добавим задержку перед перенаправлением, чтобы пользователь мог увидеть сообщение
    await Future.delayed(Duration(seconds: 2));

    // Перенаправление на PacksScreen
    Navigator.pushReplacementNamed(context, '/packs');
  }
}
