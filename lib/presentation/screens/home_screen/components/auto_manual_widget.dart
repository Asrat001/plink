import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plinko/core/utils/responsive_util.dart';
import 'package:plinko/gen/assets.gen.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AutoManualSwitch extends StatefulWidget {
  const AutoManualSwitch({super.key});

  @override
  State<AutoManualSwitch> createState() => _AutoManualSwitchState();
}

class _AutoManualSwitchState extends State<AutoManualSwitch> {
  int selectedId = 0;
  int autoAmount = 10;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 300,
          sigmaY: 300,
        ),
        child: ResponsiveBuilder(builder: (context, sizingInfo) {
          return Container(
            height: ResponsiveUtil.forScreen(
              sizingInfo: sizingInfo,
              small: 48,
              mobile: 48,
              tablet: 60,
              desktop: 70,
              large: 70,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 3.5, vertical: 3.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFFFFFFF).withOpacity(0.25),
                width: 1,
              ),
              // color: Colors.black.withOpacity(0.10),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF614D6B),
                    const Color(0xFF5D4A6A),
                    const Color(0xFF463B48).withOpacity(0.8),
                  ]),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    child: _buildSwitchButton(
                        id: 0, title: 'Manual', sizingInfo: sizingInfo),
                  ),
                ),
                Expanded(
                  child: Container(
                    child: _buildSwitchButton(
                        id: 1, title: 'Auto', sizingInfo: sizingInfo),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  _buildSwitchButton(
      {required int id,
      required String title,
      required SizingInformation sizingInfo}) {
    return InkWell(
      onTap: () async {
        setState(() {
          selectedId = id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 600),
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  border: id == selectedId
                      ? Border.all(
                          color: const Color(0xFFFFCAEB).withOpacity(0.5),
                          width: 0.5,
                        )
                      : null,
                  gradient: id == selectedId
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                              Color(0xFFFFA7DE),
                              Color(0xFFFF77CC),
                            ])
                      : null,
                  borderRadius: BorderRadius.circular(7)),
              child: Container(
                  padding: const EdgeInsets.only(left: 15),
                  alignment: sizingInfo.screenSize.width < 400
                      ? id == selectedId && id == 1
                          ? Alignment.centerLeft
                          : Alignment.center
                      : Alignment.center,
                  child: RichText(
                    text: TextSpan(
                        text: title,
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  color: id == selectedId
                                      ? const Color(0xFF61003C)
                                      : const Color(0xFFFFFFFF),
                                  fontSize: ResponsiveUtil.forScreen(
                                    sizingInfo: sizingInfo,
                                    small: 12,
                                    mobile: 17,
                                    tablet: 17,
                                    desktop: 17,
                                    large: 17,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                        children: [
                          if (id == selectedId && id == 1)
                            TextSpan(
                                text: ' $autoAmount',
                                style: const TextStyle(
                                  color: Color(0xFFB13D8B),
                                  fontWeight: FontWeight.w700,
                                ))
                        ]),
                  )),
            ),
            Visibility(
              visible: id == 1 && selectedId == 1,
              child: Positioned(
                right: 4,
                top: 0,
                bottom: 0,
                child: Align(
                  child: Container(
                      width: 20,
                      height: 24,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 3, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB0418D),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Assets.images.caretIcon.image(
                        width: 20,
                        height: 20,
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
