import 'package:axoproject/view/components/border_radius.dart';
import 'package:axoproject/view/components/heights.dart';
import 'package:axoproject/view/components/small_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:sizer/sizer.dart';

class HomeGridTile extends StatelessWidget {
  final String title;
  final String image;
  final bool isDisable;
  const HomeGridTile({Key? key, required this.title, required this.image, this.isDisable=false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 43.w,
      height: 13.h,
      decoration: BoxDecoration(
        borderRadius: commonRadius,
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 8.w,
            height: 8.w,
            child: SvgPicture.asset(
              image,
              color: isDisable   ? Colors.grey.withOpacity(0.5) : Theme.of(context).primaryColor,
            ),
          ),
          commonHeight2,
          SmallText(
            title: title,
          ),
        ],
      ),
    );
  }
}
