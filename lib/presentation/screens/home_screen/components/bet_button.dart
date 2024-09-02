import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/utils/responsive_util.dart';

class BetButton extends StatelessWidget {
  final String? title;
  final LinearGradient? gradient;
  final Color? textColor;
  final Function()? onTab;
  const BetButton({
    super.key,
    this.gradient,
    this.title,
    this.textColor,
    this.onTab,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTab,
      child: ResponsiveBuilder(builder: (context, sizingInfo) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10,
              sigmaY: 10,
            ),
            child: Container(
              height: ResponsiveUtil.forScreen(
                sizingInfo: sizingInfo,
                small: 48,
                mobile: 48,
                tablet: 60,
                desktop: 70,
                large: 70,
              ),
              decoration: BoxDecoration(
                  border: Border.all(
                    color: const Color(0xFFFFFFFF).withOpacity(0.2),
                    width: 1,
                  ),
                  gradient: gradient ??
                      const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xFFFFA7DE),
                            Color(0xFFFF77CC),
                          ]),
                  borderRadius: BorderRadius.circular(12)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  title ?? "Place Bet",
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: textColor ?? const Color(0xFF61003C),
                        fontSize: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          small: 16,
                          mobile: 18,
                          tablet: 19,
                          desktop: 20,
                          large: 23,
                        ),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
