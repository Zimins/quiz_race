class QuizRepository {
  final demoQuiz1 = Quiz(
    'a',
    '대한민국의 수도는?',
    '대한민국의 수도는 서울입니다',
    '서울',
    ['서울', '부산', '대구', '분당'],
    'thumbnailUrl',
    1,
  );

  final demoQuiz2 = Quiz(
    'b',
    '구글이 만든 모바일 운영체제는?',
    'Android',
    'Android',
    ['Android', 'iOS', 'Tigen', 'Chrome'],
    'thumbnailUrl',
    1,
  );

  int count = 0;

  Quiz getNextQuiz(String originalId) {
    final demoQuizList = [demoQuiz1, demoQuiz2];
    return demoQuizList[(count++ % 2)];
  }

  Quiz getQuiz(String id) {
    final demoQuizList = [demoQuiz1, demoQuiz2];
    return demoQuiz1;
  }

  List<Quiz> getQuizes(int length) {
    final demoQuiz = Quiz(
      'sss',
      '대한민국의 수도는?',
      '대한민국의 수도는 서울입니다',
      '서울',
      ['서울', '부산', '대구', '분당'],
      'thumbnailUrl',
      1,
    );
    return [demoQuiz];
  }
}

class Quiz {
  String id;
  String question;
  String answerDescription;
  String answer;
  List<String> answerChoices;
  String thumbnailUrl;
  int difficulty;

  Quiz(
    this.id,
    this.question,
    this.answerDescription,
    this.answer,
    this.answerChoices,
    this.thumbnailUrl,
    this.difficulty,
  );
}
