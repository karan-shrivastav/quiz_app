import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../widgets/button_widget.dart';
import '../../widgets/text_field_widget.dart';

class QuestionUploadPage extends StatefulWidget {
  const QuestionUploadPage({super.key});

  @override
  _QuestionUploadPageState createState() => _QuestionUploadPageState();
}

class _QuestionUploadPageState extends State<QuestionUploadPage> {
  final TextEditingController questionController = TextEditingController();
  final List<TextEditingController> optionControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  int? correctOptionIndex;

  Future<void> uploadQuestion() async {
    String question = questionController.text;
    List<String> options = optionControllers.map((c) => c.text).toList();

    if (question.isNotEmpty &&
        options.every((option) => option.isNotEmpty) &&
        correctOptionIndex != null) {
      await FirebaseFirestore.instance.collection('questions').add({
        'questionText': question,
        'options': options,
        'correctAnswer': correctOptionIndex,
      });
      questionController.clear();
      for (var controller in optionControllers) {
        controller.clear();
      }
      setState(() {
        correctOptionIndex = null;
      });

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Question uploaded successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content:
              Text('Please fill all fields and select a correct option.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Quiz Questions'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextfieldWidget(
              controller: questionController,
              hintText: 'Enter Question',
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Radio<int>(
                        value: index,
                        groupValue: correctOptionIndex,
                        onChanged: (value) {
                          setState(() {
                            correctOptionIndex = value;
                          });
                        },
                      ),
                      title: TextfieldWidget(
                        controller: optionControllers[index],
                        hintText: 'Option ${index + 1}',
                      ),
                    );
                  }),
            ),
            const SizedBox(height: 20),
            ButtonWidget(
              funstion: () {
                uploadQuestion();
              },
              title: 'Save',
            )
          ],
        ),
      ),
    );
  }
}
