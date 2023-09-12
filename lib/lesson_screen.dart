import 'package:flutter/material.dart';
import 'services/initialization_service.dart';

class LessonScreen extends StatefulWidget {
  final InitializationService initializationService;

  LessonScreen({required this.initializationService});

  @override
  _LessonScreenState createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  int currentWordIndex = 0;
  int currentPoints = 0;
  List<Word>? lessonWords;
  List<WordOption>? currentWordOptions;

  @override
  void initState() {
    super.initState();
    _initializeLesson();
  }

  _initializeLesson() async {
    lessonWords = await widget.initializationService.getRandomWordsForLesson();
    _loadOptionsForCurrentWord();
  }

  _loadOptionsForCurrentWord() async {
    currentWordOptions = await widget.initializationService.getWordOptionsFor(lessonWords![currentWordIndex], widget.initializationService.selectedCategories![0]);
    setState(() {});
  }

  _handleAnswerTap(WordOption option) {
    if (option.word == lessonWords![currentWordIndex].word) {
      // TODO: Handle correct answer
      setState(() {
        currentPoints += 10;
        currentWordIndex++;
      });
      _loadOptionsForCurrentWord();
    } else {
      // TODO: Handle wrong answer
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _PointsCard(points: currentPoints),
            _ProgressCard(index: currentWordIndex + 1, total: widget.initializationService.wordsCountForStudy!),
          ],
        ),
        // TODO: Add Image Card for current word
        ...currentWordOptions!.map((option) => _AnswerCard(option: option, onTap: _handleAnswerTap))
      ],
    );
  }
}

class _PointsCard extends StatelessWidget {
  final int points;

  _PointsCard({required this.points});

  @override
  Widget build(BuildContext context) {
    return Card(
      // TODO: Style the card
      child: Row(
        children: [
          Icon(Icons.star),
          Text("$points очков"),
        ],
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
      // TODO: Style the card
      child: Text("$index/$total"),
    );
  }
}

class _AnswerCard extends StatelessWidget {
  final WordOption option;
  final Function onTap;

  _AnswerCard({required this.option, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      // TODO: Style the card
      child: ListTile(
        title: Text(option.word),
        onTap: () => onTap(option),
      ),
    );
  }
}
