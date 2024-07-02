import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class SmallText extends StatelessWidget {
  final String title;
  const SmallText({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'Rubik',
        color: mutedColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}
