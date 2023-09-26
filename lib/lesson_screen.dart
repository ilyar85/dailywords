import 'package:flutter/material.dart';
import 'services/initialization_service.dart';
import 'package:provider/provider.dart';

class LessonScreen extends StatefulWidget {
  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int currentWordIndex = 0;
  int currentPoints = 0;
  List<Word>? lessonWords;
  List<WordOption>? currentWordOptions;
  String? imageUrl; // Добавим это свойство для хранения URL-адреса изображения
  Color? selectedAnswerColor;
  WordOption? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _initializeLesson();
  }

  _initializeLesson() async {
    final initializationService =
        Provider.of<InitializationService>(context, listen: false);
    lessonWords = await initializationService.getRandomWordsForLesson();
    // Получаем URL-адрес изображения для текущего слова
    if (lessonWords != null && lessonWords!.isNotEmpty) {
      imageUrl = await initializationService.getImageUrlForWord(
          lessonWords![currentWordIndex].word,
          initializationService
              .selectedCategories![0] // Это предполагаемая категория слова
          );
    }
    _loadOptionsAndImageForCurrentWord();
  }

  _loadOptionsAndImageForCurrentWord() async {
    final initializationService =
        Provider.of<InitializationService>(context, listen: false);
    currentWordOptions = await initializationService.getWordOptionsFor(
        lessonWords![currentWordIndex],
        initializationService.selectedCategories![0]);

    // Добавим загрузку URL изображения для следующего слова
    if (lessonWords != null && lessonWords!.isNotEmpty) {
      imageUrl = await initializationService.getImageUrlForWord(
          lessonWords![currentWordIndex].word,
          initializationService
              .selectedCategories![0] // Это предполагаемая категория слова
          );
    }

    setState(() {}); // Обновить состояние, чтобы перестроить виджет
  }

  void _finishLesson() async {
    final initializationService =
        Provider.of<InitializationService>(context, listen: false);

    // Здесь записываем результаты урока в базу данных
    //await initializationService.saveLessonResults(currentPoints);

    // Возвращаемся на экран LearningScreen
    //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LearningScreen()));
  }

  _handleAnswerTap(WordOption option) {
    setState(() {
      selectedAnswer = option;
      if (option.word == lessonWords![currentWordIndex].word) {
        selectedAnswerColor = Colors.blue; // Синий цвет для правильного ответа
        currentPoints += 10;
      } else {
        selectedAnswerColor = null; // Не меняем цвет для неправильного ответа
      }
    });

    // Проверка на последнее слово
    if (currentWordIndex == lessonWords!.length - 1) {
      _finishLesson();
    } else {
      Future.delayed(Duration(seconds: 1), () {
        setState(() {
          selectedAnswer = null; // Сбрасываем выбранный ответ
          currentWordIndex++;
          // Здесь мы загружаем данные для следующего слова
          _initializeLesson();
          _loadOptionsAndImageForCurrentWord();
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final initializationService =
        Provider.of<InitializationService>(context, listen: false);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 60, // Увеличено по высоте
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: _PointsCard(points: currentPoints),
                  ),
                  SizedBox(width: 8), // Добавлен отступ между карточками
                  Expanded(
                    child: _ProgressCard(
                      index: currentWordIndex + 1,
                      total: initializationService.wordsCountForStudy!,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Expanded(
              child: Center(
                child: imageUrl != null
                    ? _ImageCard(
                        imageUrl: imageUrl!,
                        transcription:
                            lessonWords![currentWordIndex].transcription)
                    : SizedBox(),
              ),
            ),
            SizedBox(height: 8),
            ...currentWordOptions
                    ?.map((option) => _AnswerCard(
                          option: option,
                          onTap: _handleAnswerTap,
                          color: option == selectedAnswer
                              ? selectedAnswerColor
                              : null, // Устанавливаем цвет
                        ))
                    .toList() ??
                [Center(child: CircularProgressIndicator())],
          ],
        ),
      ),
    );
  }
}

class _PointsCard extends StatelessWidget {
  final int points;

  _PointsCard({required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Updated to 30
      ),
      child: Container(
        height: 60, // Set height
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Color(0xFF6F6F6F)),
            SizedBox(width: 8),
            Text("$points очков", style: TextStyle(color: Color(0xFF6F6F6F))),
          ],
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  final int index;
  final int total;

  _ProgressCard({required this.index, required this.total});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Updated to 30
      ),
      child: Container(
        height: 60, // Set height
        padding: EdgeInsets.all(10),
        child: Center(
          child:
              Text("$index/$total", style: TextStyle(color: Color(0xFF6F6F6F))),
        ),
      ),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final WordOption option;
  final Function onTap;
  final Color? color; // Добавим параметр для цвета

  _AnswerCard({required this.option, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color, // Устанавливаем цвет карточки
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
        title: Center(
          child: Text(
            option.rus,
            style: TextStyle(color: Color(0xFF6F6F6F)),
          ),
        ),
        onTap: () => onTap(option),
      ),
    );
  }
}

class _ImageCard extends StatelessWidget {
  final String imageUrl;
  final String transcription;

  _ImageCard({required this.imageUrl, required this.transcription});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30), // Updated to 30
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30), // Updated to 30
        child: Container(
          height: 300,
          width: double.infinity,
          //decoration: BoxDecoration(
          //  border: Border.all(width: 2.0, color: Colors.grey), // Border added
          //),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 150, // 300 * 0.75 = 225 to reduce the size by 25%
                width: double.infinity,
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: 8),
              Text(transcription, style: TextStyle(color: Color(0xFF6F6F6F))),
            ],
          ),
        ),
      ),
    );
  }
}
