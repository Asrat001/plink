import 'dart:math';

import 'package:flutter/material.dart';
import 'package:plinko/core/utils/responsive_util.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BackgroundBalls extends StatelessWidget {
  const BackgroundBalls({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 9; i++)
                  Row(
                    children: [
                      for (int j = i; j < 9; j++) _buildBall(sizingInfo, i),
                    ],
                  )
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                for (int i = 0; i < 9; i++)
                  Row(
                    children: [
                      for (int j = i; j < 9; j++) _buildBall(sizingInfo, i),
                    ],
                  )
              ],
            ),
          ],
        ),
      );
    });
  }

  _buildBall(SizingInformation sizingInfo, int i) {
    final randomNumber = Random().nextInt(9);
    return Container(
      width: 5,
      height: 5,
      margin: EdgeInsets.only(
        left: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 4,
          mobile: 6,
          tablet: 11,
          desktop: 15,
          large: 15,
        ),
        right: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 4,
          mobile: 6,
          tablet: 11,
          desktop: 15,
          large: 15,
        ),
        bottom: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 22,
          mobile: 22,
          tablet: 20,
          desktop: 35,
          large: 40,
        ),
      ),
      decoration: BoxDecoration(
        color: i == randomNumber
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.03),
        shape: BoxShape.circle,
      ),
    );
  }
}
