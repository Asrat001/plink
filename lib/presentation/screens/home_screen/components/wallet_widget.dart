import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:plinko/gen/assets.gen.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../bloc/auth/auth_bloc.dart';
import '../../../../core/utils/responsive_util.dart';

class WalletWidget extends StatefulWidget {
  final bool isBig;
  final Function() onTab;
  final bool showSignIn;
  const WalletWidget(
      {super.key,
      this.isBig = false,
      required this.onTab,
      this.showSignIn = false});

  @override
  State<WalletWidget> createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTab,
      child: Align(
        alignment: Alignment.centerRight,
        child: ClipRRect(
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
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      spreadRadius: 5,
                      blurRadius: 7,
                      blurStyle: BlurStyle.inner,
                      offset: const Offset(0, 3), // changes position of shadow
                    )
                  ],
                  gradient: const LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFF503D49),
                        Color(0xFF453C4C),
                        Color(0xFF3A464E),
                      ]),
                ),
                child: widget.showSignIn
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.login,
                            size: 24,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Sign In',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontSize: 17,
                                ),
                          )
                        ],
                      )
                    : widget.isBig
                        ? Padding(
                            padding: EdgeInsets.only(
                                left: ResponsiveUtil.forScreen(
                              sizingInfo: sizingInfo,
                              mobile: 15,
                              tablet: 16,
                              desktop: 16,
                              large: 16,
                            )),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.wallet,
                                  color: Colors.white,
                                  size: ResponsiveUtil.forScreen(
                                    sizingInfo: sizingInfo,
                                    mobile: 24,
                                    tablet: 30,
                                    desktop: 33,
                                    large: 33,
                                  ),
                                ),
                                const SizedBox(width: 7),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Wallet',
                                      style: TextStyle(
                                        fontSize: ResponsiveUtil.forScreen(
                                          sizingInfo: sizingInfo,
                                          small: 12,
                                          mobile: 17,
                                          tablet: 17,
                                          desktop: 17,
                                          large: 17,
                                        ),
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const MarqueeText(
                                      speed: 25,
                                      text: TextSpan(
                                        text: 'Balance: 364.498',
                                        style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xFFF3DBF2),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        : BlocBuilder<AuthBloc, AuthState>(
                            builder: (context, state) {
                              return Center(
                                child: state.isLoggedIn
                                    ? Assets.images.checkIcon.image()
                                    : const Icon(
                                        Icons.wallet,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                              );
                            },
                          ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
