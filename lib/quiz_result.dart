import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuizResultPage extends StatelessWidget {
  int score = 0;

  QuizResultPage(this.score);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Spacer(),
          Text(
            '당신의 점수는',
            textAlign: TextAlign.center,
          ),
          Text(
            score.toString(),
            textAlign: TextAlign.center,
          ),
          Spacer(),
          ElevatedButton(
            onPressed: () {
              Navigator.popUntil(
                context,
                (route) {
                  return route.isFirst;
                },
              );
            },
            child: Text('홈으로'),
          )
        ],
      ),
    );
  }
}
