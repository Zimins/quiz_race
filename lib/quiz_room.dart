import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quiz_race/quiz_controller.dart';
import 'package:quiz_race/quiz_repository.dart';
import 'package:quiz_race/quiz_result.dart';

class QuizRoom extends StatefulWidget {
  @override
  _QuizRoomState createState() => _QuizRoomState();
}

class _QuizRoomState extends State<QuizRoom> {
  int score = 0;
  List<Quiz> quizList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return QuizPage(
              quizId: "",
              onCorrect: () {
                score += 1;
              },
              onIncorrect: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return QuizResultPage(score);
                  },
                ));
              },
              onFinished: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) {
                    return QuizResultPage(score);
                  },
                ));
              });
        },
      ),
    );
  }

  loadNewQuizList() {
    final repo = QuizRepository();
    quizList = repo.getQuizes(10);
  }
}

class QuizPage extends StatefulWidget {

  QuizPage({
    required this.quizId,
    required this.onCorrect,
    required this.onIncorrect,
    required this.onFinished,
  });

  final String quizId;

  final VoidCallback onCorrect;

  final VoidCallback onIncorrect;

  final VoidCallback onFinished;

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  String question = '';
  List<String> choices = [];
  String answer = '';
  String selectedAnswer = '';
  String quizId = '';

  int gameLimitTime = 5;

  final repo = QuizRepository();

  @override
  void initState() {
    super.initState();
    startTimer();
    loadSingleQuiz('');
  }

  @override
  Widget build(BuildContext context) {

    final quizController = Get.put(QuizController());

    return Center(
        child: Column(
      children: [
        Spacer(),
        Text(question),
        Expanded(
          child: Obx(() => Text('${quizController.leftSeconds}')),
        ),
        ChoiceButtons(
          choices,
          onSelected: (answer) {
            selectedAnswer = answer;
          },
        ),
      ],
    ));
  }

  loadSingleQuiz(String quizId) {
    final quiz = repo.getNextQuiz(quizId);
    setState(() {
      question = quiz.question;
      choices = quiz.answerChoices;
      quizId = quiz.id;
    });
    answer = quiz.answer;
  }

  onTimeChange(Timer timer) {
    final QuizController controller = Get.find();

    setState(() {
      controller.setLeftSeconds(gameLimitTime - timer.tick);

      if (controller.leftSeconds.value == 0) {
        timer.cancel();
        checkAnswer();
      }
    });
  }

  startTimer() {
    final timer = Timer.periodic(Duration(seconds: 1), onTimeChange);
  }

  checkAnswer() {
    // update score
    if (answer == selectedAnswer) {
      widget.onCorrect();
      loadSingleQuiz(quizId);
      startTimer();
    } else {
      widget.onIncorrect();
    }
  }

  quitGame() {
    widget.onFinished();
  }
}

class ChoiceButtons extends StatelessWidget {

  ChoiceButtons(
    this.choices, {
    required this.onSelected,
  });

  final List<String> choices;

  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
                child: SingleChoice(
              text: choices[0],
              onSelected: () {
                onSelected(choices[0]);
              },
            )),
            Expanded(
                child: SingleChoice(
              text: choices[1],
              onSelected: () {
                onSelected(choices[1]);
              },
            )),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(
              child: SingleChoice(
                text: choices[2],
                onSelected: () {
                  onSelected(choices[2]);
                },
              ),
            ),
            Expanded(
                child: SingleChoice(
              text: choices[3],
              onSelected: () {
                onSelected(choices[2]);
              },
            )),
          ],
        ),
      ],
    );
  }
}

class SingleChoice extends StatelessWidget {

  SingleChoice({
    required this.text,
    required this.onSelected,
  });

  final String text;

  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: onSelected,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      ),
    );
  }
}
