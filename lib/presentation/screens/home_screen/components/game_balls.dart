import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/utils/responsive_util.dart';

class GameBalls extends StatefulWidget {
  const GameBalls({super.key});

  @override
  State<GameBalls> createState() => _GameBallsState();
}

class _GameBallsState extends State<GameBalls> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: SizedBox()),
        // ResponsiveBuilder(builder: (context, sizingInfo) {
        //   return Column(
        //     crossAxisAlignment: CrossAxisAlignment.center,
        //     children: [
        //       for (int i = 0; i < 9; i++)
        //         Row(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             for (int j = 0; j < (i + 3); j++) _buildBall(sizingInfo)
        //           ],
        //         )
        //     ],
        //   );
        // }),
        ResponsiveBuilder(builder: (context, sizingInfo) {
          return SizedBox(
            height: ResponsiveUtil.forScreen(
              sizingInfo: sizingInfo,
              small: 15,
              mobile: 25,
              tablet: 30,
              desktop: 30,
              large: 30,
            ),
          );
        }),
        Padding(
          padding: const EdgeInsets.only(bottom: 15, left: 15, right: 15),
          child: ResponsiveBuilder(builder: (context, sizingInfo) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildBottomBox(
                  color: const Color(0xFFFFB4FF),
                  text: '10x',
                  textColor: const Color(0xFFA13DA1),
                  sizingInfo: sizingInfo,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    bottomLeft: Radius.circular(15),
                    bottomRight: Radius.circular(6),
                    topRight: Radius.circular(6),
                  ),
                ),
                _buildBottomBox(
                  text: '5x',
                  color: const Color(0xFFFFACFF),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFA839A8),
                ),
                _buildBottomBox(
                  text: '2x',
                  color: const Color(0xFFFF9FFF),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFCC32CC),
                ),
                _buildBottomBox(
                    text: '1.5',
                    color: const Color(0xFFEE97ED),
                    sizingInfo: sizingInfo,
                    textColor: const Color(0xFFDD30DB)),
                _buildBottomBox(
                  text: '0.9',
                  color: const Color(0xFF773F6B),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFEE9DDF),
                ),
                _buildBottomBox(
                  text: '0.7',
                  color: const Color(0xFF6C345D),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFE99BDA),
                ),
                _buildBottomBox(
                  text: '0.9',
                  color: const Color(0xFF773F6B),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFEE9DDF),
                ),
                //

                _buildBottomBox(
                    text: '1.5',
                    color: const Color(0xFFEE97ED),
                    sizingInfo: sizingInfo,
                    textColor: const Color(0xFFE150DD)),
                _buildBottomBox(
                  text: '2x',
                  color: const Color(0xFFFF9FFF),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFCC5FCC),
                ),
                _buildBottomBox(
                  text: '5x',
                  color: const Color(0xFFFFACFF),
                  sizingInfo: sizingInfo,
                  textColor: const Color(0xFFA76AA7),
                ),
                _buildBottomBox(
                  color: const Color(0xFFFFB4FF),
                  sizingInfo: sizingInfo,
                  text: '10x',
                  textColor: const Color(0xFFA06DA0),
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(15),
                    bottomRight: Radius.circular(15),
                    bottomLeft: Radius.circular(6),
                    topLeft: Radius.circular(6),
                  ),
                ),
              ],
            );
          }),
        )
      ],
    );
  }

  Widget _buildBall(SizingInformation sizingInfo) {
    return Container(
      width: 5,
      height: 5,
      margin: EdgeInsets.only(
        right: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 11,
          mobile: 12,
          tablet: 25,
          desktop: 25,
          large: 25,
        ),
        left: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 11,
          mobile: 12,
          tablet: 25,
          desktop: 25,
          large: 25,
        ),
        top: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 25,
          mobile: 27,
          tablet: 40,
          desktop: 35,
          large: 40,
        ),
      ),
      decoration: const BoxDecoration(
        color: Colors.black,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildBottomBox(
      {required String text,
      required Color color,
      required Color textColor,
      required SizingInformation sizingInfo,
      BorderRadius? borderRadius}) {
    return Container(
      height: 27,
      width: ResponsiveUtil.forScreen(
        sizingInfo: sizingInfo,
        small: 25,
        mobile: borderRadius != null
            ? sizingInfo.localWidgetSize.width < 350
                ? 39.75
                : 59.75
            : 25,
        tablet: 50,
        desktop: 50,
        large: 50,
      ),
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius ?? BorderRadius.circular(6),
      ),
      child: Center(
        child: Text(
          text,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 13,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
        ),
      ),
    );
  }
}
