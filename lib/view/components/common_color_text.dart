import 'package:flutter/material.dart';
class CommonColorText extends StatelessWidget {
  final String title;
  final double fontSize;
  final FontWeight fontWeight;
  const CommonColorText(
      {Key? key,
      required this.title,
      required this.fontSize,
      this.fontWeight = FontWeight.w400})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            fontFamily: 'Rubik',
            color: Theme.of(context).highlightColor,
            fontSize: fontSize,
            fontWeight: fontWeight));
  }
}
