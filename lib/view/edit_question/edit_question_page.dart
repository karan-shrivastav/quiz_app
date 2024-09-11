import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditQuestionPage extends StatefulWidget {
  final DocumentSnapshot questionDoc;

  EditQuestionPage({required this.questionDoc});

  @override
  _EditQuestionPageState createState() => _EditQuestionPageState();
}

class _EditQuestionPageState extends State<EditQuestionPage> {
  final _formKey = GlobalKey<FormState>();
  late String _questionText;
  late List<String> _options;
  late int _correctAnswer;

  @override
  void initState() {
    super.initState();
    _questionText = widget.questionDoc['questionText'];
    _options = List<String>.from(widget.questionDoc['options']);
    _correctAnswer = widget.questionDoc['correctAnswer'];
  }

  void _updateQuestion() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      await FirebaseFirestore.instance
          .collection('questions')
          .doc(widget.questionDoc.id)
          .update({
        'questionText': _questionText,
        'options': _options,
        'correctAnswer': _correctAnswer,
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Question'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  initialValue: _questionText,
                  decoration: const InputDecoration(
                    labelText: 'Question',
                  ),
                  onSaved: (value) => _questionText = value ?? '',
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter a question'
                      : null,
                ),
                ...List.generate(_options.length, (index) {
                  return TextFormField(
                    initialValue: _options[index],
                    decoration:
                        InputDecoration(labelText: 'Option ${index + 1}'),
                    onSaved: (value) {
                      if (value != null) {
                        _options[index] = value;
                      }
                    },
                    validator: (value) => value == null || value.isEmpty
                        ? 'Please enter an option'
                        : null,
                  );
                }),
                DropdownButtonFormField<int>(
                  value: _correctAnswer,
                  decoration:
                      const InputDecoration(labelText: 'Correct Answer'),
                  onChanged: (value) =>
                      setState(() => _correctAnswer = value ?? 0),
                  items: List.generate(_options.length, (index) {
                    return DropdownMenuItem(
                      value: index,
                      child: Text('Option ${index + 1}'),
                    );
                  }),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _updateQuestion,
                  child: const Text('Update Changes'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
