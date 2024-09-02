import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:plinko/gen/assets.gen.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/utils/responsive_util.dart';

class BalanceWidget extends StatefulWidget {
  final bool showSignIn;
  const BalanceWidget({super.key, this.showSignIn = false});

  @override
  State<BalanceWidget> createState() => _BalanceWidgetState();
}

class _BalanceWidgetState extends State<BalanceWidget> {
  double bet = 0.006;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 10.0,
          sigmaY: 10.0,
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
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1),
                    blurStyle: BlurStyle.inner)
              ],
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color(0xFF4E3943),
                    const Color(0xFF3B444C).withOpacity(0.8),
                    const Color(0xFF5D5670),
                    const Color(0xFF695D78),
                  ]),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                  left: ResponsiveUtil.forScreen(
                    sizingInfo: sizingInfo,
                    mobile: 15,
                    tablet: 16,
                    desktop: 16,
                    large: 16,
                  ),
                  right: 5),
              child: widget.showSignIn
                  ? Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Not signed in",
                        style:
                            Theme.of(context).textTheme.titleMedium!.copyWith(
                                  fontSize: 17,
                                  color: Colors.white60,
                                ),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Assets.images.soloanaIcon.image(
                              width: 20,
                              height: 20,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  transitionBuilder: (Widget child,
                                      Animation<double> animation) {
                                    final offsetAnimation = Tween<Offset>(
                                      begin: child.key == ValueKey(bet)
                                          ? const Offset(0.0, 1.0)
                                          : const Offset(0.0, -1.0),
                                      end: const Offset(0.0, 0.0),
                                    ).animate(animation);

                                    final fadeAnimateion = Tween<double>(
                                      begin: 0.5,
                                      end: 1.0,
                                    ).animate(animation);

                                    return ClipRect(
                                      child: SlideTransition(
                                        position: offsetAnimation,
                                        child: ScaleTransition(
                                          scale: animation,
                                          child: FadeTransition(
                                            opacity: fadeAnimateion,
                                            child: child,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                  child: SizedBox(
                                    width: 80,
                                    key: ValueKey(bet),
                                    child: Text(
                                      "$bet",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(
                                            fontSize: ResponsiveUtil.forScreen(
                                              sizingInfo: sizingInfo,
                                              small: 12,
                                              mobile: 17,
                                              tablet: 17,
                                              desktop: 17,
                                              large: 17,
                                            ),
                                            fontWeight: FontWeight.w700,
                                          ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Bet Amount",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                        fontSize: ResponsiveUtil.forScreen(
                                          sizingInfo: sizingInfo,
                                          mobile: 10,
                                          tablet: 12,
                                          desktop: 13,
                                          large: 15,
                                        ),
                                        color: const Color(0xFFF3DBF2),
                                        fontWeight: FontWeight.w500,
                                      ),
                                )
                              ],
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _balanceButton(
                                title: 'MIN',
                                sizingInfo: sizingInfo,
                                onTab: () {
                                  setState(() {
                                    bet = 0;
                                  });
                                }),
                            _balanceButton(
                                title: '2x',
                                sizingInfo: sizingInfo,
                                onTab: () {
                                  setState(() {
                                    bet = 0.003;
                                  });
                                }),
                            _balanceButton(
                                title: 'MAX',
                                sizingInfo: sizingInfo,
                                onTab: () {
                                  setState(() {
                                    bet = 0.006;
                                  });
                                }),
                          ],
                        )
                      ],
                    ),
            ),
          );
        }),
      ),
    );
  }

  _balanceButton(
      {required String title,
      required Function() onTab,
      required SizingInformation sizingInfo}) {
    return InkWell(
      onTap: onTab,
      child: Container(
          margin: EdgeInsets.only(
            left: ResponsiveUtil.forScreen(
              sizingInfo: sizingInfo,
              mobile: 7,
              tablet: 8,
              desktop: 8,
              large: 8,
            ),
          ),
          width: ResponsiveUtil.forScreen(
            sizingInfo: sizingInfo,
            mobile: 36,
            tablet: 46,
            desktop: 55,
            large: 60,
          ),
          height: ResponsiveUtil.forScreen(
            sizingInfo: sizingInfo,
            mobile: 36,
            tablet: 46,
            desktop: 55,
            large: 60,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF4E435B),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    color: Colors.white,
                    fontSize: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      mobile: 13,
                      tablet: 13,
                      desktop: 15,
                      large: 19,
                    ),
                  ),
            ),
          )),
    );
  }
}
