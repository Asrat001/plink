import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ContainerWidget extends StatelessWidget {
  final Widget child;
  final double? height;
  const ContainerWidget({super.key, required this.child, this.height});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 128,
            sigmaY: 128,
          ),
          child: Container(
            width: 100.sh,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                  BoxShadow(
                    color: Colors.white.withOpacity(0.25),
                    spreadRadius: -16,
                    blurRadius: 64,
                    blurStyle: BlurStyle.inner,
                    offset: const Offset(0, 32), // changes position of shadow
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: -32,
                    blurRadius: 32,
                    blurStyle: BlurStyle.inner,
                    offset: const Offset(0, -32), // changes position of shadow
                  ),
                  // BoxShadow(
                  //   color: Colors.white.withOpacity(0.25),
                  //   spreadRadius: 0.5,
                  //   blurRadius: 0,
                  //   blurStyle: BlurStyle.inner,
                  //   offset: const Offset(0, 0), // changes position of shadow
                  // ),
                  // BoxShadow(
                  //   color: Colors.white.withOpacity(0.25),
                  //   spreadRadius: 0.5,
                  //   blurRadius: 0,
                  //   blurStyle: BlurStyle.inner,
                  //   offset: const Offset(0, 0), // changes position of shadow
                  // ),
                  // BoxShadow(
                  //   color: Colors.white.withOpacity(0.25),
                  //   spreadRadius: 0.5,
                  //   blurRadius: 0,
                  //   blurStyle: BlurStyle.inner,
                  //   offset: const Offset(0, 0), // changes position of shadow
                  // )
                ],
                border: Border.all(
                  color: const Color(0xFF73577D).withOpacity(0.1),
                ),
                // color: ColorName.foregroundColor,
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      const Color(0xFF393139),
                      const Color(0xFF393139).withOpacity(0.95),
                      const Color(0xFF332B33).withOpacity(0.95),
                      const Color(0xFF332B33),
                    ])),
            child: child,
          ),
        ),
      ),
    );
  }
}
