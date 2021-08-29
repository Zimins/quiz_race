import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
              onFinish: () {
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
  String quizId;
  VoidCallback onCorrect;
  VoidCallback onIncorrect;
  VoidCallback onFinish;

  QuizPage({
    required this.quizId,
    required this.onCorrect,
    required this.onIncorrect,
    required this.onFinish,
  });

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
  int leftSeconds = 5;

  final repo = QuizRepository();

  @override
  void initState() {
    super.initState();
    startTimer();
    loadSingleQuiz('');
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Spacer(),
        Text(question),
        Expanded(
          child: Text(leftSeconds.toString()),
        ),
        ChoiceButtons(
          choices,
          onSelect: (answer) {
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
    setState(() {
      leftSeconds = gameLimitTime - timer.tick;
      if (leftSeconds == 0) {
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
    widget.onFinish();
  }
}

class ChoiceButtons extends StatelessWidget {
  List<String> choices;
  ValueChanged<String> onSelect;

  ChoiceButtons(this.choices, {required this.onSelect});

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
              onSelect: () {
                onSelect(choices[0]);
              },
            )),
            Expanded(
                child: SingleChoice(
              text: choices[1],
              onSelect: () {
                onSelect(choices[1]);
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
                onSelect: () {
                  onSelect(choices[2]);
                },
              ),
            ),
            Expanded(
                child: SingleChoice(
              text: choices[3],
              onSelect: () {
                onSelect(choices[2]);
              },
            )),
          ],
        ),
      ],
    );
  }
}

class SingleChoice extends StatelessWidget {
  String text = '';
  VoidCallback onSelect;

  SingleChoice({required this.text, required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: OutlinedButton(
        onPressed: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(text),
        ),
      ),
    );
  }
}
