import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class LargeText extends StatelessWidget {
  final String title;
  final Color color;
  const LargeText({Key? key, required this.title, required this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 14,
        color: color,
        fontWeight: FontWeight.w400,
        fontFamily: 'Rubik',
      ),
    );
  }
}
