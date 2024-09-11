import 'package:flutter/material.dart';
import 'package:quiz_demo/view/questions_view_screen.dart';
import '../widgets/text_widget.dart';

class QuizzCompleteScreen extends StatelessWidget {
  int totalScore;
  QuizzCompleteScreen({
    super.key,
    required this.totalScore,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextWidget(
          text: 'Quizz completed',
        ),
      ),
      body: Center(
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
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => QuestionDisplayPage(),
                  ),
                );
              },
              child: const TextWidget(
                text: 'Restart Quiz',
                color: Colors.black,
              ),
            )
          ],
        ),
      ),
    );
    ;
  }
}
