import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextAlign? textAlign;
  final TextOverflow? overFlow;

  const TextWidget({
    super.key,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.textAlign,
    this.overFlow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      softWrap: true,
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.white,
      ),
      maxLines: 3,
      textAlign: textAlign,
    );
  }
}