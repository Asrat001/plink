import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../core/utils/responsive_util.dart';

class RiskWidget extends StatefulWidget {
  final bool isBig;
  const RiskWidget({super.key, this.isBig = false});

  @override
  State<RiskWidget> createState() => _RiskWidgetState();
}

class _RiskWidgetState extends State<RiskWidget> {
  IconData riskIcon = Icons.whatshot;
  String riskText = 'High';
  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return InkWell(
        onTap: () {
          setState(() {
            if (riskText == 'High') {
              riskText = 'Low';
              riskIcon = Icons.waves_outlined;
            } else if (riskText == 'Med') {
              riskText = 'High';
              riskIcon = Icons.whatshot_rounded;
            } else {
              riskText = 'Med';
              riskIcon = Icons.flash_on;
            }
          });
        },
        child: Container(
          clipBehavior: Clip.antiAlias,
          height: ResponsiveUtil.forScreen(
            sizingInfo: sizingInfo,
            small: 48,
            mobile: 48,
            tablet: 60,
            desktop: 70,
            large: 70,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0), // Rounded corners
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF2E3F45),
                  Color(0xFF2B3B42),
                ]),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(2, 2),
                blurRadius: 6,
              ),
            ],
          ),
          child: (widget.isBig)
              ? Row(
                  mainAxisAlignment: widget.isBig
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.bounceInOut,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: child.key == ValueKey(riskText)
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
                            child: FadeTransition(
                              opacity: fadeAnimateion,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        key: ValueKey(riskIcon),
                        riskIcon, // Placeholder for the flame icon
                        color: const Color(0xFF81D4FA),
                        size: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          mobile: 24,
                          tablet: 30,
                          desktop: 30,
                          large: 35,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedSwitcher(
                          switchInCurve: Curves.bounceIn,
                          duration: const Duration(milliseconds: 350),
                          transitionBuilder:
                              (Widget child, Animation<double> animation) {
                            final offsetAnimation = Tween<Offset>(
                              begin: child.key == ValueKey(riskText)
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
                            key: ValueKey<String>(riskText),
                            width: 50,
                            child: Text(
                              riskText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveUtil.forScreen(
                                  sizingInfo: sizingInfo,
                                  small: 13,
                                  mobile: 17,
                                  tablet: 17,
                                  desktop: 17,
                                  large: 17,
                                ),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Risk',
                          style: TextStyle(
                            color: const Color(0xFF81D4FA),
                            fontSize: ResponsiveUtil.forScreen(
                              sizingInfo: sizingInfo,
                              mobile: 11,
                              tablet: 12,
                              desktop: 13,
                              large: 14,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 38,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedSwitcher(
                            switchInCurve: Curves.bounceIn,
                            duration: const Duration(milliseconds: 350),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              final offsetAnimation = Tween<Offset>(
                                begin: child.key == ValueKey(riskText)
                                    ? const Offset(0.0, 1.0)
                                    : const Offset(0.0, -1.0),
                                end: const Offset(0.0, 0.0),
                              ).animate(animation);

                              final fadeAnimateion = Tween<double>(
                                begin: 0.8,
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
                            child: Text(
                              key: ValueKey<String>(riskText),
                              riskText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: ResponsiveUtil.forScreen(
                                  sizingInfo: sizingInfo,
                                  small: 12,
                                  mobile: 15,
                                  tablet: 18,
                                  desktop: 15,
                                  large: 22,
                                ),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(
                            'Risk',
                            style: TextStyle(
                              color: const Color(0xFF81D4FA),
                              fontSize: ResponsiveUtil.forScreen(
                                sizingInfo: sizingInfo,
                                mobile: 10,
                                tablet: 12,
                                desktop: 10,
                                large: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: ResponsiveUtil.forScreen(
                        sizingInfo: sizingInfo,
                        mobile: 2,
                        tablet: 10,
                        desktop: 10,
                        large: 10,
                      ),
                    ),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 350),
                      switchInCurve: Curves.bounceIn,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        final offsetAnimation = Tween<Offset>(
                          begin: child.key == ValueKey(riskText)
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
                            child: FadeTransition(
                              opacity: fadeAnimateion,
                              child: child,
                            ),
                          ),
                        );
                      },
                      child: Icon(
                        key: ValueKey(riskIcon),
                        riskIcon, // Placeholder for the flame icon
                        color: const Color(0xFF81D4FA),
                        size: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          mobile: 24,
                          tablet: 30,
                          desktop: 20,
                          large: 33,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      );
    });
  }
}
