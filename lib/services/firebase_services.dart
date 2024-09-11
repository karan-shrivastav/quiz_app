import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Services {
  late Stream<QuerySnapshot> questionStream;
  Map<int, int?> selectedOptions = {};
  Map<int, bool?> answerCorrectness = {};
  int totalScore = 0;
  bool quizFinished = false;
  int revealedQuestionsCount = 1;

  void selectOption(int questionIndex, int selectedOptionIndex,
      int correctAnswerIndex, int totalQuestions) {
    //setState(() {
      selectedOptions[questionIndex] = selectedOptionIndex;
      answerCorrectness[questionIndex] =
          selectedOptionIndex == correctAnswerIndex;
      if (answerCorrectness[questionIndex]!) {
        totalScore += 5;
      }
      if (revealedQuestionsCount < totalQuestions) {
        revealedQuestionsCount++;
      } else if (questionIndex == totalQuestions - 1) {
        quizFinished = true;
        submitScore();
      }
  //  });
  }

  Future<void> submitScore() async {
    await FirebaseFirestore.instance.collection('quizResults').add({
      'score': totalScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

}