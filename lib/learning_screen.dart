import 'package:flutter/material.dart';
import 'services/initialization_service.dart';
import 'themes/app_theme.dart';
import 'lesson_screen.dart';

class LearningScreen extends StatefulWidget {
  final InitializationService initializationService;

  LearningScreen({required this.initializationService});

  @override
  _LearningScreenState createState() => _LearningScreenState();
}

class _LearningScreenState extends State<LearningScreen> {
  bool canStartLesson = false;
  bool canRepeatLastLesson = false;
  bool isFirstLesson = false;

  @override
  void initState() {
    super.initState();
    _checkLessonAvailability();
  }

  Future<void> _checkLessonAvailability() async {
    // ... оставшийся код проверки
    isFirstLesson = widget.initializationService.learnedWords == null ||
        widget.initializationService.learnedWords!.isEmpty;
    if (isFirstLesson) {
      canStartLesson = true;
    } else if (widget.initializationService.lastLessonCompletionTime != null &&
        DateTime.now()
                .difference(
                    widget.initializationService.lastLessonCompletionTime!)
                .inHours <
            24) {
      canStartLesson = false;
      canRepeatLastLesson = true;
    } else {
      canStartLesson = true;
      canRepeatLastLesson = false;
    }

    setState(() {}); // чтобы обновить интерфейс после изменения состояния
    print(
        'isFirstLesson: $isFirstLesson, canStartLesson: $canStartLesson, canRepeatLastLesson: $canRepeatLastLesson');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: _getCurrentLayout(),
    );
  }

  Widget _getCurrentLayout() {
    if (isFirstLesson && canStartLesson) {
      return _firstLessonLayout();
    } else if (canRepeatLastLesson) {
      return _repeatLessonLayout();
    } else {
      return _startNextLessonLayout();
    }
  }

  Widget _firstLessonLayout() {
    print('::::_firstLessonLayout');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment
          .stretch, // для растягивания элементов по горизонтали
      children: [
        Text(
          "Категории успешно выбраны",
          style: appTheme.textTheme.displayLarge
              ?.copyWith(fontWeight: FontWeight.bold),
          textAlign: TextAlign.center, // центрируем текст по горизонтали
        ),
        SizedBox(height: 16), // небольшой отступ между элементами
        Text(
          "Теперь настало время начать свой захватывающий тест",
          style: appTheme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 16),
        Center(
          child: Image.asset(
            "assets/done.png",
            fit: BoxFit
                .cover, // это убедится, что изображение растянется, но сохранит свои пропорции
          ),
        ),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            _startTest();
          },
          child: Text("Начать тест", style: appTheme.textTheme.bodyLarge),
        ),
      ],
    );
  }

  Widget _repeatLessonLayout() {
    print('::::_repeatLessonLayout');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Ты молодец", style: Theme.of(context).textTheme.bodyLarge),
        Text("${widget.initializationService.userPoints}/10",
            style: Theme.of(context).textTheme.bodyMedium),
        // TODO: добавьте ваш логотип или другую картинку
        Text("Увидимся через", style: Theme.of(context).textTheme.bodyMedium),
        // TODO: добавить виджет таймера
        ElevatedButton(
          onPressed: () {
            // TODO: начать тест заново
          },
          child: Text("Пройти тест заново",
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

  Widget _startNextLessonLayout() {
    print('::::_startNextLessonLayout');
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {
            _startTest();
          },
          child: Text("Начать тест",
              style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }

void _startTest() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => LessonScreen(initializationService: widget.initializationService),
    ),
  );
}

}
