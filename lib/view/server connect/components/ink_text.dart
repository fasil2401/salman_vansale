import 'package:flutter/material.dart';

class InkText extends StatelessWidget {
  final String title;
  const InkText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(
        color: Theme.of(context).highlightColor,
        fontSize: 12,
        fontFamily: 'Rubik',
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
