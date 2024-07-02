import 'package:axoproject/utils/constants/colors.dart';
import 'package:axoproject/view/components/draggable_button.dart';
import 'package:flutter/material.dart';

class DragableButton extends StatelessWidget {
  DragableButton({Key? key, required this.onTap, required this.icon})
      : super(key: key);

  Function() onTap;
  Widget icon;

  @override
  Widget build(BuildContext context) {
    return DraggableCard(
      child: InkWell(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastLinearToSlowEaseIn,
          height: 50,
          width: 50,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Center(
              child: icon,
            ),
          ),
        ),
      ),
    );
  }
}
