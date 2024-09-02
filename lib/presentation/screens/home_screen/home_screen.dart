import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko/bloc/auth/auth_bloc.dart';
import 'package:plinko/gen/assets.gen.dart';
import 'package:plinko/presentation/screens/home_screen/components/game_displayer.dart';
import 'package:plinko/presentation/screens/login_screen/login_screen.dart';
import 'package:plinko/presentation/screens/music_screen/components/plinko_back_button.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../chat_screen/chat_screen.dart';
import '../music_screen/music_screen.dart';
import '../wallet_screen/wallet_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  double columnWidth = 360;

  double? screenHeight;
  double? screenWidth;
  double? mainPageHeight;
  double? mainPageWidth;
  double reducedMainScreenHeight = 60;
  double reducedMainScreenWidth = 400;
  bool squeezed = false;
  bool hide_header = false;
  double mainPageRoundness = 0;

  String backgroundPage = '';

  // Animation Controller for smoother animation
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthInit());

    // Initialize animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 700), // Adjust animation duration
      vsync: this,
    );

    // Create animation with a smooth curve
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut, // Use a smooth curve
      ),
    );
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        log('animation completed');
        setState(() {
          squeezed = true;
        });
      } else if (status == AnimationStatus.reverse) {
        setState(() {
          squeezed = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void squeeze() {
    if (mainPageHeight != null && mainPageHeight != screenHeight) {
      return;
    }
    hide_header = false;
    // Start the animation forward
    _animationController.forward();
  }

  void expand() {
    hide_header = false;
    // Start the animation reverse
    _animationController.reverse();
  }

  void setBackgroundPage(String page) {
    setState(() {
      backgroundPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    reducedMainScreenWidth = screenWidth! * 0.9;

    return Scaffold(
      body: Stack(fit: StackFit.expand, children: [
        if (backgroundPage == 'wallet') const Align(child: WalletScreen()),
        if (backgroundPage == 'chat') Align(child: ChatScreen()),
        if (backgroundPage == 'music') const Align(child: MusicScreen()),
        if (backgroundPage == 'login')
          Align(
              child: LoginScreen(
            setBackground: setBackgroundPage,
            squeeze: squeeze,
          )),
        if (backgroundPage != 'login')
          ClipRRect(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                // Calculate width and height based on animation value
                double currentWidth = lerpDouble(
                    screenWidth!, reducedMainScreenWidth, _animation.value)!;
                double currentHeight = lerpDouble(
                    screenHeight!, reducedMainScreenHeight, _animation.value)!;
                mainPageRoundness = lerpDouble(0, 20, _animation.value)!;
                // Print values for debugging

                return Align(
                    alignment: const Alignment(0, -0.8),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(mainPageRoundness),
                        child: Container(
                          width: currentWidth,
                          height: currentHeight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(
                                  Assets.images.backgroundImage.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: squeezed
                              ? Visibility(
                                  visible: backgroundPage != 'login',
                                  child: Stack(
                                    children: [
                                      GameDisplayer(
                                        expand: expand,
                                        squeeze: squeeze,
                                        squeezed: squeezed,
                                        hide_header: hide_header,
                                        setBackgroundPage: setBackgroundPage,
                                      ),
                                      GestureDetector(
                                          onTap: () {
                                            expand();
                                          },
                                          child: SizedBox(
                                            width: 100.sh,
                                            child: PlinkoBackButton(
                                                reducedMainScreenHeight:
                                                    reducedMainScreenHeight),
                                          ))
                                    ],
                                  ),
                                )
                              : GameDisplayer(
                                  expand: expand,
                                  squeeze: squeeze,
                                  squeezed: squeezed,
                                  hide_header: hide_header,
                                  setBackgroundPage: setBackgroundPage,
                                ),
                        )));
              },
            ),
          )
      ]),
    );
  }
}
