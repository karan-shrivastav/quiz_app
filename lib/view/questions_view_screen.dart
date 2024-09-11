import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quiz_demo/view/questions_upload/questions_upload.dart';
import 'package:quiz_demo/widgets/text_widget.dart';
import 'edit_question/edit_question_page.dart';

class QuestionDisplayPage extends StatefulWidget {
  @override
  _QuestionDisplayPageState createState() => _QuestionDisplayPageState();
}

class _QuestionDisplayPageState extends State<QuestionDisplayPage> {
  late Stream<QuerySnapshot> questionStream;
  Map<int, int?> selectedOptions = {};
  Map<int, bool?> answerCorrectness = {};
  int totalScore = 0;
  bool quizFinished = false;
  int revealedQuestionsCount = 1;

  @override
  void initState() {
    super.initState();
    questionStream =
        FirebaseFirestore.instance.collection('questions').snapshots();
  }

  void selectOption(int questionIndex, int selectedOptionIndex,
      int correctAnswerIndex, int totalQuestions) {
    setState(() {
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
    });
  }

  Future<void> submitScore() async {
    await FirebaseFirestore.instance.collection('quizResults').add({
      'score': totalScore,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  void _editQuestion(DocumentSnapshot questionDoc) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditQuestionPage(questionDoc: questionDoc),
      ),
    );
  }

  void _restartQuiz() {
    setState(() {
      selectedOptions.clear();
      answerCorrectness.clear();
      totalScore = 0;
      quizFinished = false;
      revealedQuestionsCount = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Questions'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const QuestionUploadPage(),
                  ),
                );
              },
              child: Text('Add Questions'))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: questionStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No questions..'));
          }
          var questions = snapshot.data!.docs;
          int totalQuestions = questions.length;
          if (quizFinished) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const TextWidget(
                    text: 'Quiz Completed!',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  TextWidget(
                    text: 'Your Total Score: $totalScore',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _restartQuiz();
                    },
                    child: const TextWidget(
                      text: 'Restart Quiz',
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: revealedQuestionsCount,
            itemBuilder: (context, index) {
              var question = questions[index];
              var options = question['options'] as List<dynamic>;
              int correctAnswerIndex = question['correctAnswer'];

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          question['questionText'],
                          style: const TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ...List.generate(options.length, (optionIndex) {
                          bool isSelected =
                              selectedOptions[index] == optionIndex;
                          return GestureDetector(
                            onTap: () {
                              if (selectedOptions[index] == null) {
                                selectOption(index, optionIndex,
                                    correctAnswerIndex, totalQuestions);
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 5.0),
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? Colors.grey[200]
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Text(
                                options[optionIndex],
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 10),
                        Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editQuestion(question),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
