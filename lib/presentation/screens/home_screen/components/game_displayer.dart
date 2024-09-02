import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:icons_plus/icons_plus.dart';
import 'package:plinko/core/constants/model_identifier.dart';
import 'package:plinko/core/utils/responsive_util.dart';
import 'package:plinko/core/utils/settings.dart';
import 'package:plinko/presentation/screens/home_screen/components/auto_manual_widget.dart';
import 'package:plinko/presentation/screens/home_screen/components/balance_widget.dart';
import 'package:plinko/presentation/screens/home_screen/components/game_balls.dart';
import 'package:plinko/presentation/screens/home_screen/components/risk_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../../bloc/auth/auth_bloc.dart';
import '../../../../core/utils/device_model.dart';
import 'background_balls.dart';
import 'bet_button.dart';
import 'wallet_widget.dart';

class GameDisplayer extends StatefulWidget {
  final Function expand;
  final Function squeeze;
  final bool squeezed;
  final bool hide_header;
  final Function setBackgroundPage;
  const GameDisplayer(
      {super.key,
      required this.expand,
      required this.squeeze,
      required this.squeezed,
      required this.hide_header,
      required this.setBackgroundPage});

  @override
  State<GameDisplayer> createState() => _GameDisplayerState();
}

class _GameDisplayerState extends State<GameDisplayer> {
  String backgroundPage = '';

  double columnWidth = 40.sh;
  bool isManual = true;
  double dragPosition = 0.0;
  double autoSliderMargin = 3;
  double autoSliderWidth = 240;
  double ristWidth = 80;
  double buttonsHeight = 60;
  double horizontalSpacingWidth = 18;
  String riskText = 'Low';
  IconData ristIcon = Icons.air;

  double alignment = 0;
  double? screenHeight;
  double? screenWidth;
  double? mainPageHeight;
  double? mainPageWidth;
  double reducedMainScreenHeight = 100;
  double reducedMainScreenWidth = 400;

  List<Offset> pegs = [];
  List<Ball> balls = [];
  bool isBallFalling = false;
  bool showBalls = false;
  bool isAuto = false;
  Completer<void>? _ballUpdateCompleter;

  String? deviceModel;

  /*// Plinko physics customization
  double pegSpacing = 35;
  int rows = 10;
  double initialXVelocityRange = 1; // i.e. -0.8 to 0.8
  double initialXPositionRange = 0.5; // i.e. -0.15 to 0.15
  double x_acceleration = 1.75;
  double y_acceleration = 4;
  double base_y_acceleration = 0.9;*/

  // Score and multipliers
  double score = 0;
  double multipliersY = 480;
  List<Multiplier> multipliers = [
    Multiplier(position: 0, value: 10),
    Multiplier(position: 1, value: 5),
    Multiplier(position: 2, value: 2),
    Multiplier(position: 3, value: 1.5),
    Multiplier(position: 4, value: 0.9),
    Multiplier(position: 5, value: 0.7),
    Multiplier(position: 6, value: 0.9),
    Multiplier(position: 7, value: 1.5),
    Multiplier(position: 8, value: 2),
    Multiplier(position: 9, value: 5),
    Multiplier(position: 10, value: 10),
  ];

  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void initState() {
    super.initState();
    deviceModel = getDeviceModel();
    print("deviceModel $deviceModel");
  }

  void _initializePegs(double contextWidth, double contextHeight) {
    double leftPadding = 0;
    if (contextWidth < 367) {
      leftPadding = max(0, 16 - (367 - contextWidth) / 2) + 2.5;
    } else {
      leftPadding = 16 + 2.5;
    }
    double topPadding = pegSpacingY;

    pegs = [];

    for (int row = 2; row < rows; row++) {
      for (int col = 0; col <= row; col++) {
        double x = -leftPadding +
            (contextWidth / 2) -
            ((row - 1 + 1) * pegSpacingX) / 2 +
            (col * pegSpacingX);
        double y = topPadding + ((row - 2) * pegSpacingY);
        pegs.add(Offset(x, y));
      }
    }
  }

  void _startBallDrop() async {
    setState(() {
      double x_pos_init = (columnWidth * 0.5 +
          Random().nextDouble() * initialXPositionRange * 2 -
          initialXPositionRange);

      if (x_pos_init > columnWidth * 0.5) {
        x_pos_init += 20;
      }
      if (x_pos_init < columnWidth * 0.5) {
        x_pos_init -= 20;
      }
      balls.add(Ball(
        position: Offset(x_pos_init, 0),
        velocity: Offset(
            Random().nextDouble() * initialXVelocityRange * 2 -
                initialXVelocityRange,
            1),
      ));
      isBallFalling = true;
    });
    if (balls.length == 1) {
      _updateBallPositions();
    }
  }

  // Plinko physics customization
  double pegSpacingX = 29;
  double pegSpacingY = 32;
  int rows = 11;
  double initialXVelocityRange = 1; // i.e. -0.8 to 0.8
  double initialXPositionRange = 0.5; // i.e. -0.15 to 0.15
  double xAcceleration = 1.6;
  double yAcceleration = 3;
  double baseYAcceleration = 0.7;
  double catchDistance = 10;

  void _updateBallPositions() async {
    if (_ballUpdateCompleter != null && !_ballUpdateCompleter!.isCompleted) {
      return;
    }

    _ballUpdateCompleter = Completer<void>();

    while (isBallFalling) {
      await Future.delayed(const Duration(milliseconds: 16));
      setState(() {
        for (var ball in balls) {
          ball.position += ball.velocity;
          ball.velocity += Offset(0, baseYAcceleration);

          for (Offset peg in pegs) {
            if ((ball.position - peg).distance < catchDistance) {
              double angle =
                  atan2(ball.position.dy - peg.dy, ball.position.dx - peg.dx);
              ball.velocity = Offset(
                  xAcceleration * cos(angle), yAcceleration * sin(angle));
              _audioPlayer.play(AssetSource('../sounds/plink.mp3'));
            }
          }

          // ball reached a bucket
          if ((multipliersY - ball.position.dy) < 5) {
            int hitIndex =
                (((ball.position.dx) / columnWidth) * multipliers.length)
                    .floor();
            score = multipliers[hitIndex].value;
            //_audioPlayer.play(AssetSource('score_${hitIndex + 1}.mp3'));
            _audioPlayer.play(AssetSource('../sounds/plink.mp3'));
            Future.delayed(const Duration(milliseconds: 500), () {
              setState(() {});
            });

            balls.remove(ball);
            break;
          }
        }

        if (balls.isEmpty) {
          isBallFalling = false;
        }
      });
    }

    _ballUpdateCompleter!.complete();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.center,
        child: ResponsiveBuilder(builder: (context, sizingInfo) {
          return Visibility(
            visible: backgroundPage != 'login',
            child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              _initializePegs(constraints.maxWidth, constraints.maxHeight);
              return Container(
                margin: EdgeInsets.only(
                  left: widget.squeezed
                      ? 0
                      : (constraints.maxWidth < 367)
                          ? max(0, 16 - (367 - constraints.maxWidth) / 2)
                          : 16,
                  right: widget.squeezed
                      ? 0
                      : (constraints.maxWidth < 367)
                          ? max(0, 16 - (367 - constraints.maxWidth) / 2)
                          : 16,
                ),
                width: ResponsiveUtil.forScreen(
                  sizingInfo: sizingInfo,
                  small: 100.sw,
                  mobile: 100.sw,
                  tablet: 90.sw,
                  desktop: 50.sh,
                  large: 40.sh,
                ),
                child: Align(
                    alignment: Alignment(0, -0.5),
                    child: OverflowBox(
                        maxHeight: MediaQuery.of(context).size.height,
                        alignment: Alignment(0, -0.5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildHeader(),
                            _buildPlinko(),
                            _buildBottom(),
                          ],
                        ))),
              );
            }),
          );
        }),
      ),
    );
  }

  _buildBottom() {
    return Expanded(
      flex: 2,
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          return ResponsiveBuilder(builder: (context, sizingInfo) {
            if (state.isLoggedIn == false) {
              return _buildNonLoggedInScreen(sizingInfo);
            } else {
              return deviceModel == iphone14ProModelId ||
                      deviceModel == iphone13ProModelId ||
                      deviceModel == iphone12ProModelId
                  ? _buildSmallScreen(sizingInfo)
                  : deviceModel == iphone14ProMax ||
                          deviceModel == iphone13ProMax ||
                          deviceModel == iphone12ProMax
                      ? _buildForLargeScreen()
                      : ScreenTypeLayout.builder(
                          breakpoints: const ScreenBreakpoints(
                            watch: 427,
                            desktop: 950,
                            tablet: 600,
                          ),
                          desktop: (_) => _buildForLargeScreen(),
                          tablet: (_) => _buildForLargeScreen(),
                          mobile: (_) => _buildForLargeScreen(),
                          watch: (_) => _buildSmallScreen(sizingInfo),
                        );
            }
          });
        },
      ),
    );
  }

  Widget _buildNonLoggedInScreen(SizingInformation sizingInfo) {
    return Column(
      children: [
        ResponsiveBuilder(builder: (context, sizingInfo) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: ResponsiveUtil.forScreen(
                            sizingInfo: sizingInfo,
                            mobile: 3,
                            tablet: 5,
                            desktop: 5,
                            large: 4)
                        .toInt(),
                    child: const AutoManualSwitch()),
                SizedBox(
                    width: ResponsiveUtil.forScreen(
                        sizingInfo: sizingInfo,
                        mobile: 10,
                        tablet: 10,
                        desktop: 15,
                        large: 15)),
                const SizedBox(width: 110, child: const RiskWidget()),
              ]);
        }),
        SizedBox(
            height: ResponsiveUtil.forScreen(
                sizingInfo: sizingInfo,
                small: 10,
                mobile: 15,
                tablet: 15,
                desktop: 20,
                large: 20)),
        ResponsiveBuilder(builder: (context, sizingInfo) {
          return Row(
            children: [
              Expanded(
                  flex: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          mobile: 3,
                          tablet: 3,
                          desktop: 3,
                          large: 3)
                      .toInt(),
                  child: const BalanceWidget(
                    showSignIn: true,
                  )),
              SizedBox(
                  width: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      mobile: 10,
                      tablet: 10,
                      desktop: 15,
                      large: 15)),
              Expanded(
                  flex: 2,
                  child: WalletWidget(
                    showSignIn: true,
                    onTab: () {
                      widget.setBackgroundPage('login');
                      widget.squeeze();
                    },
                  )),
            ],
          );
        }),
        SizedBox(
            height: ResponsiveUtil.forScreen(
                sizingInfo: sizingInfo,
                small: 10,
                mobile: 15,
                tablet: 15,
                desktop: 20,
                large: 20)),
        BetButton(
          onTab: () {
            widget.setBackgroundPage('login');
            widget.squeeze();
          },
          textColor: Colors.white70,
          title: 'Please sign in',
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Color(0xFF6D5658),
              Color(0xFF686671),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSmallScreen(SizingInformation sizingInfo) {
    return Column(
      children: [
        ResponsiveBuilder(builder: (context, sizingInfo) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    flex: ResponsiveUtil.forScreen(
                            sizingInfo: sizingInfo,
                            mobile: 3,
                            tablet: 5,
                            desktop: 5,
                            large: 4)
                        .toInt(),
                    child: const AutoManualSwitch()),
                SizedBox(
                    width: ResponsiveUtil.forScreen(
                        sizingInfo: sizingInfo,
                        mobile: 10,
                        tablet: 10,
                        desktop: 15,
                        large: 15)),
                const SizedBox(width: 110, child: const RiskWidget()),
              ]);
        }),
        SizedBox(
            height: ResponsiveUtil.forScreen(
                sizingInfo: sizingInfo,
                small: 10,
                mobile: 15,
                tablet: 15,
                desktop: 20,
                large: 20)),
        ResponsiveBuilder(builder: (context, sizingInfo) {
          return Row(
            children: [
              Expanded(
                  flex: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          mobile: 5,
                          tablet: 5,
                          desktop: 7,
                          large: 7)
                      .toInt(),
                  child: const BalanceWidget()),
              SizedBox(
                  width: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      mobile: 10,
                      tablet: 10,
                      desktop: 15,
                      large: 15)),
              Expanded(
                  flex: 1,
                  child: WalletWidget(
                    onTab: () {
                      widget.setBackgroundPage('wallet');
                      widget.squeeze();
                    },
                  )),
            ],
          );
        }),
        SizedBox(
            height: ResponsiveUtil.forScreen(
                sizingInfo: sizingInfo,
                small: 10,
                mobile: 15,
                tablet: 15,
                desktop: 20,
                large: 20)),
        BetButton(
          onTab: _startBallDrop,
        ),
      ],
    );
  }

  Widget _buildForLargeScreen() {
    return ResponsiveBuilder(builder: (contex, sizingInfo) {
      if (sizingInfo.screenSize.width < 366) {}
      return Column(
        children: [
          const AutoManualSwitch(),
          SizedBox(
              height: ResponsiveUtil.forScreen(
                  sizingInfo: sizingInfo,
                  small: 10,
                  mobile: 20,
                  tablet: 20,
                  desktop: 20,
                  large: 20)),
          Row(
            children: [
              Expanded(
                  flex: 1,
                  child: WalletWidget(
                    isBig: true,
                    onTab: () {
                      widget.setBackgroundPage('wallet');
                      widget.squeeze();
                    },
                  )),
              const SizedBox(width: 10),
              const Expanded(
                child: RiskWidget(
                  isBig: true,
                ),
              ),
            ],
          ),
          SizedBox(
              height: ResponsiveUtil.forScreen(
                  sizingInfo: sizingInfo,
                  small: 10,
                  mobile: 20,
                  tablet: 20,
                  desktop: 20,
                  large: 20)),
          const BalanceWidget(),
          SizedBox(
              height: ResponsiveUtil.forScreen(
                  sizingInfo: sizingInfo,
                  small: 10,
                  mobile: 20,
                  tablet: 15,
                  desktop: 20,
                  large: 20)),
          BetButton(
            onTab: _startBallDrop,
          ),
        ],
      );
    });
  }

  _buildPlinko() {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Container(
        margin: EdgeInsets.only(
            bottom: ResponsiveUtil.forScreen(
              sizingInfo: sizingInfo,
              small: 10,
              mobile: 20,
              tablet: 20,
              desktop: 20,
              large: 20,
            ),
            top: ResponsiveUtil.forScreen(
              sizingInfo: sizingInfo,
              small: 5,
              mobile: 15,
              tablet: 15,
              desktop: 20,
              large: 20,
            )),
        height: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 360,
          mobile: 360,
          tablet: 50.sh,
          desktop: 50.sw,
          large: 50.sw,
        ),
        child: Stack(
          children: [
            ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 256, sigmaY: 256),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white10),
                    boxShadow: [
                      BoxShadow(
                        offset: const Offset(0, 56),
                        blurStyle: BlurStyle.inner,
                        spreadRadius: -24,
                        blurRadius: 120,
                        color: const Color(0xFFFFFFFF).withOpacity(0.5),
                      ),
                      BoxShadow(
                        offset: const Offset(0, 0),
                        blurStyle: BlurStyle.inner,
                        spreadRadius: 0.5,
                        blurRadius: 0,
                        color: const Color(0xFFFFFFFF).withOpacity(0.15),
                      ),
                      BoxShadow(
                        offset: const Offset(0, 0.5),
                        blurStyle: BlurStyle.inner,
                        spreadRadius: 0,
                        blurRadius: 0.5,
                        color: const Color(0xFFFFFFFF).withOpacity(0.5),
                      ),
                      // BoxShadow(
                      //   offset: const Offset(0, 0),
                      //   blurStyle: BlurStyle.inner,
                      //   spreadRadius: 0.5,
                      //   color: const Color(0xFFFFFFFF).withOpacity(0.2),
                      // ),
                    ],
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFFCC6DC7),
                        Color(0xFFB158A5),
                        Color(0xFFA8599F),
                        Color(0xFF894F86),
                      ],
                    ),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const BackgroundBalls(),
            const GameBalls(),
            // Positioned(
            //     bottom: 50,
            //     right: 30,
            //     child: IconButton(
            //       icon: Icon(
            //         showBalls
            //             ? Icons.remove_red_eye_outlined
            //             : Icons.remove_red_eye,
            //         color: Colors.white,
            //       ),
            //       onPressed: () {
            //         setState(() {
            //           showBalls = !showBalls;
            //         });
            //       },
            //     )),

            Visibility(
              visible: true,
              child: Stack(
                children: [
                  ...pegs.map((peg) => Positioned(
                        left: peg.dx,
                        top: peg.dy,
                        child: Container(
                          width: 5,
                          height: 5,
                          margin: EdgeInsets.only(),
                          decoration: const BoxDecoration(
                            color: Colors.white70,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
                  ...balls.map((ball) => Positioned(
                        left: ball.position.dx,
                        top: ball.position.dy,
                        child: Container(
                          width: 17,
                          height: 17,
                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),
                        ),
                      )),
                  ...multipliers.map((multiplier) => Positioned(
                        left:
                            (35.sh / multipliers.length) * multiplier.position +
                                37,
                        top: multipliersY,
                        child: Container(
                          width: ((600 - 5) / multipliers.length) - 2,
                          height: 35,
                          decoration: BoxDecoration(
                              color: adjustColorBrightness(
                                  const Color(0xffff97dd),
                                  ((columnWidth / multipliers.length) *
                                                  multiplier.position +
                                              0.5 *
                                                  (columnWidth /
                                                      multipliers.length) -
                                              0.5 * columnWidth)
                                          .abs() /
                                      (columnWidth / 2)),
                              shape: BoxShape.rectangle,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10))),
                          child: Center(
                            child: Text(
                              '${multiplier.value}x',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ))
                ],
              ),
            ),
            Positioned(
              left: 15,
              right: 15,
              top: 15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 48,
                    height: 40,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          backgroundColor: const Color(0xFFA03F9B),
                        ),
                        onPressed: () {
                          widget.setBackgroundPage('music');
                          widget.squeeze();
                        },
                        child: const Center(
                            child: Icon(
                          Bootstrap.music_note_beamed,
                          color: Colors.white,
                          size: 23,
                        ))),
                  ),
                  SizedBox(
                    width: 48,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: const Color(0xFFA03F9B),
                      ),
                      onPressed: () {
                        //
                      },
                      child: Align(
                        alignment: Alignment.center,
                        child: Text(
                          '13',
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    fontSize: 21,
                                  ),
                        ),
                      ),
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {

                  // widget.setBackgroundPage('music');
                  // widget.squeeze();
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       color: Color(0xff9f379a).withOpacity(0.6),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.2),
                  //           spreadRadius: 1,
                  //           blurRadius: 1,
                  //           offset: Offset(0, 1),
                  //         ),
                  //       ],
                  //     ),
                  //     child:,
                  //   ),
                  // ),
                  // GestureDetector(
                  //   onTap: () {
                  //     widget.setBackgroundPage('chat');
                  //     widget.squeeze();
                  //   },
                  //   child: Container(
                  //     height: 50,
                  //     width: 50,
                  //     decoration: BoxDecoration(
                  //       borderRadius: BorderRadius.circular(10.0),
                  //       color: Color(0xff9f379a).withOpacity(0.4),
                  //       boxShadow: [
                  //         BoxShadow(
                  //           color: Colors.black.withOpacity(0.2),
                  //           spreadRadius: 1,
                  //           blurRadius: 1,
                  //           offset: const Offset(0, 1),
                  //         ),
                  //       ],
                  //     ),
                  //     child: const Icon(Icons.chat, color: Colors.white),
                  //   ),
                  // ),
                ],
              ),
            ),
          ],
        ),
      );
    });
    // return Expanded(
    //   child: Container(
    //     color: Colors.amber,
    //     child: Stack(
    //       alignment: Alignment.center,
    //       children: [
    //         Column(
    //           crossAxisAlignment: CrossAxisAlignment.center,
    //           children: [
    //             Container(
    //               color: Colors.blueAccent,
    //               padding: const EdgeInsets.all(8.0),
    //               child: Row(
    //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
    //                 children: [
    //                   GestureDetector(
    //                     onTap: () {
    //                       widget.setBackgroundPage('music');
    //                       widget.squeeze();
    //                     },
    //                     child: Container(
    //                       height: 50,
    //                       width: 50,
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(15.0),
    //                         color: Color(0xff9f379a).withOpacity(0.6),
    //                         boxShadow: [
    //                           BoxShadow(
    //                             color: Colors.black.withOpacity(0.2),
    //                             spreadRadius: 1,
    //                             blurRadius: 1,
    //                             offset: Offset(0, 1),
    //                           ),
    //                         ],
    //                       ),
    //                       child: Icon(Icons.music_note, color: Colors.white),
    //                     ),
    //                   ),
    //                   GestureDetector(
    //                     onTap: () {
    //                       widget.setBackgroundPage('chat');
    //                       widget.squeeze();
    //                     },
    //                     child: Container(
    //                       height: 50,
    //                       width: 50,
    //                       decoration: BoxDecoration(
    //                         borderRadius: BorderRadius.circular(10.0),
    //                         color: Color(0xff9f379a).withOpacity(0.4),
    //                         boxShadow: [
    //                           BoxShadow(
    //                             color: Colors.black.withOpacity(0.2),
    //                             spreadRadius: 1,
    //                             blurRadius: 1,
    //                             offset: Offset(0, 1),
    //                           ),
    //                         ],
    //                       ),
    //                       child: Icon(Icons.chat, color: Colors.white),
    //                     ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           ],
    //         ),
    //         ...pegs.map((peg) => Positioned(
    //               left: peg.dx,
    //               top: peg.dy,
    //               child: Container(
    //                 width: 7,
    //                 height: 7,
    //                 decoration: const BoxDecoration(
    //                   color: Colors.white,
    //                   shape: BoxShape.circle,
    //                 ),
    //               ),
    //             )),
    //         ...balls.map((ball) => Positioned(
    //               left: ball.position.dx,
    //               top: ball.position.dy,
    //               child: Container(
    //                 width: 17,
    //                 height: 17,
    //                 decoration: const BoxDecoration(
    //                   color: Colors.black,
    //                   shape: BoxShape.circle,
    //                 ),
    //               ),
    //             )),
    //         ...multipliers.map((multiplier) => Positioned(
    //               left:
    //                   (columnWidth / multipliers.length) * multiplier.position +
    //                       1,
    //               top: multipliersY,
    //               child: Container(
    //                 width: ((columnWidth - 5) / multipliers.length) - 2,
    //                 height: 35,
    //                 decoration: BoxDecoration(
    //                     color: adjustColorBrightness(
    //                         const Color(0xffff97dd),
    //                         ((columnWidth / multipliers.length) *
    //                                         multiplier.position +
    //                                     0.5 *
    //                                         (columnWidth / multipliers.length) -
    //                                     0.5 * columnWidth)
    //                                 .abs() /
    //                             (columnWidth / 2)),
    //                     shape: BoxShape.rectangle,
    //                     borderRadius: BorderRadius.all(Radius.circular(10))),
    //                 child: Center(
    //                   child: Text(
    //                     '${multiplier.value}x',
    //                     style: TextStyle(
    //                         color: Colors.white, fontWeight: FontWeight.bold),
    //                   ),
    //                 ),
    //               ),
    //             )),
    //       ],
    //     ),
    //   ),
    // );
  }

  _buildHeader() {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Padding(
        padding: const EdgeInsets.only(top: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Plinko!',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontSize: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      small: 25,
                      mobile: 34,
                      tablet: 34,
                      desktop: 35,
                      large: 35,
                    ),
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Row(children: [
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      mobile: 8,
                      tablet: 8,
                      desktop: 10,
                      large: 15,
                    ),
                  ),
                ),
                onPressed: () {
                  //
                },
                child: Text(
                  'Twitter',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white70,
                        fontSize: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          mobile: 19,
                          tablet: 19,
                          desktop: 24,
                          large: 24,
                        ),
                      ),
                ),
              ),
              TextButton(
                style: TextButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      mobile: 8,
                      tablet: 8,
                      desktop: 10,
                      large: 15,
                    ),
                  ),
                ),
                onPressed: () {
                  //
                },
                child: Text(
                  'Discord',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        color: Colors.white70,
                        fontSize: ResponsiveUtil.forScreen(
                          sizingInfo: sizingInfo,
                          mobile: 19,
                          tablet: 19,
                          desktop: 24,
                          large: 24,
                        ),
                      ),
                ),
              ),
              PopupMenuButton(
                icon: Container(
                  padding: const EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white70,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Icon(
                    Icons.more_horiz,
                    color: Colors.white70,
                    size: ResponsiveUtil.forScreen(
                      sizingInfo: sizingInfo,
                      mobile: 18,
                      tablet: 22,
                      desktop: 23,
                      large: 23,
                    ),
                  ),
                ),
                itemBuilder: (context) => [
                  _buildPopupMenuItem(name: 'Customer Support'),
                  _buildPopupMenuItem(name: 'How to play'),
                  _buildPopupMenuItem(name: 'AML'),
                  _buildPopupMenuItem(name: 'KYC'),
                  _buildPopupMenuItem(name: 'Terms & Conditions'),
                  _buildPopupMenuItem(name: 'Privacy Policy'),
                  _buildPopupMenuItem(name: 'Responsible Gaming'),
                  _buildPopupMenuItem(name: 'Logout',
                    onTab: () {
                      context.read<AuthBloc>().add(
                            ChangeLogginStatus(isLoggedIn: false),
                          );
                      setLogginStatus(false);
                    },
                  ),
                ],
              ),
            ])
          ],
        ),
      );
    });
  }

  Widget _buildMultiplier(
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

  PopupMenuItem _buildPopupMenuItem({required String name, Function()? onTab}) {
    return PopupMenuItem(
        onTap: onTab,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
        child: Text(
          name,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ));
  }
}

Color adjustColorBrightness(Color color, double amount) {
  assert(amount >= 0 && amount <= 1);

  amount = 1.0 - amount;
  final hsl = HSLColor.fromColor(color);
  final adjustment = (0.2 + amount * 0.6);
  final adjustedHsl = hsl.withLightness((adjustment).clamp(0.0, 1));
  return adjustedHsl.toColor();
}

class Ball {
  Offset position;
  Offset velocity;

  Ball({required this.position, required this.velocity});
}

class Multiplier {
  double position;
  double value;

  Multiplier({required this.position, required this.value});
}
