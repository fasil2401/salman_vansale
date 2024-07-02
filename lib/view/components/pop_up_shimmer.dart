import 'package:axoproject/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerProvider {
  static Widget popShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: 4,
        itemBuilder: (context, index) {
          return const Card(
              child: Padding(
            padding:  EdgeInsets.all(8.0),
            child: Text(
              "Location",
              style: TextStyle(
                color: AppColors.mutedColor,
              ),
            ),
          ));
        },
        separatorBuilder: (context, index) =>const SizedBox(
          height: 5,
        ),
      ),
    );
  }
}