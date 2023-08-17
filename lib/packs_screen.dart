import 'package:flutter/material.dart';
import 'services/initialization_service.dart';

class PacksScreen extends StatefulWidget {
  @override
  _PacksScreenState createState() => _PacksScreenState();
}

class _PacksScreenState extends State<PacksScreen> {
  int? selectedWordsCount;

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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 48.0,
                      horizontal: 16.0), // Увеличил отступы по вертикали
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('количество', style: TextStyle(fontSize: 41)),
                      SizedBox(height: 8),
                      Text(
                        'Выберите один из трех доступных режимов для вашего ежедневного теста.',
                        style:
                            TextStyle(color: Color(0xFF6F6F6F), fontSize: 10),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              _buildPackOption(5),
              SizedBox(height: 10),
              _buildPackOption(10),
              SizedBox(height: 10),
              _buildPackOption(15),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    if (selectedWordsCount != null) {
                      // Обновление значения wordsCountForStudy в InitializationService
                      await InitializationService()
                          .setWordsCountForStudy(selectedWordsCount!);
                      Navigator.pushNamed(context, '/categories');
                    } else {
                      // TODO: Показать пользователю предупреждение
                      print("Пожалуйста, выберите количество слов.");
                    }
                  },
                  child: Text('продолжить'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Color(0xFF6F6F6F)),
                    minimumSize: MaterialStateProperty.all(Size(300, 50)),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(38),
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

  Widget _buildPackOption(int wordsCount) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedWordsCount = wordsCount;
        });
      },
      child: Container(
        height: 100, // Установил фиксированную высоту для кнопок
        decoration: BoxDecoration(
          color: Color(0xFF151515),
          border: Border.all(
            color: selectedWordsCount == wordsCount
                ? Colors.blue
                : Colors.transparent,
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(30.0),
        ),
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text(
              '${wordsCount.toString().padLeft(2, ' ')} слов',
              style: TextStyle(
                fontSize: 18,
                color: selectedWordsCount == wordsCount
                    ? Color(0xFF003AFF)
                    : Color(0xFF6F6F6F),
                fontWeight: FontWeight.bold,
              ),
            ),
            VerticalDivider(
                color: Color(0xFF6F6F6F),
                thickness: 1), // Изменил на вертикальный разделитель
            Expanded(
              child: Text(
                'Каждый день вы будете получать $wordsCount новых слов. За каждый успешный ответ вам будут начисляться очки.',
                style: TextStyle(
                  color: selectedWordsCount == wordsCount
                      ? Colors.white
                      : Color(0xFF6F6F6F),
                  fontSize: 10,
                  fontWeight: FontWeight.w400,
                  height: 1.20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
