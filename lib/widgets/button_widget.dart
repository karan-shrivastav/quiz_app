import 'package:flutter/material.dart';
import 'package:quiz_demo/widgets/text_widget.dart';

class ButtonWidget extends StatelessWidget {
  final Function funstion;
  final String title;
  const ButtonWidget({super.key, required this.funstion, required this.title});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        onPressed: () {
          funstion();
        },
        child: TextWidget(
          text: title,
        ),
      ),
    );
  }
}
