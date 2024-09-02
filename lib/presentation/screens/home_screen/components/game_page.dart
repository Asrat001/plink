import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:responsive_builder/responsive_builder.dart';

class GamePage extends StatefulWidget {
  final Function expand;
  final Function squeeze;
  final bool squeezed;
  final Function setBackgroundPage;

  const GamePage(
      {super.key,
      required this.expand,
      required this.squeeze,
      required this.squeezed,
      required this.setBackgroundPage});

  @override
  GamePageState createState() => GamePageState();
}

class GamePageState extends State<GamePage> {
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
  Completer<void>? _ballUpdateCompleter;

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
  double multipliersY = 400;
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
    _initializePegs();
  }

  void _initializePegs() {
    pegs = [];
    for (int row = 2; row < rows; row++) {
      for (int col = 0; col <= row; col++) {
        double x =
            (columnWidth / 2) - (row * pegSpacing / 2) + (col * pegSpacing);
        double y = (row * pegSpacing);
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
  double pegSpacing = 35;
  int rows = 14;
  double initialXVelocityRange = 1; // i.e. -0.8 to 0.8
  double initialXPositionRange = 0.5; // i.e. -0.15 to 0.15
  double x_acceleration = 1.6;
  double y_acceleration = 3;
  double base_y_acceleration = 0.7;
  double catch_distance = 10;

  void _updateBallPositions() async {
    if (_ballUpdateCompleter != null && !_ballUpdateCompleter!.isCompleted) {
      return;
    }

    _ballUpdateCompleter = Completer<void>();

    while (isBallFalling) {
      await Future.delayed(Duration(milliseconds: 16));
      setState(() {
        for (var ball in balls) {
          ball.position += ball.velocity;
          ball.velocity += Offset(0, base_y_acceleration);

          for (Offset peg in pegs) {
            if ((ball.position - peg).distance < catch_distance) {
              double angle =
                  atan2(ball.position.dy - peg.dy, ball.position.dx - peg.dx);
              ball.velocity = Offset(
                  x_acceleration * cos(angle), y_acceleration * sin(angle));
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
            Future.delayed(Duration(milliseconds: 500), () {
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

  void _showSettingsPopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context1) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter modalSetState) {
            return Container(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Adjust Game Settings',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    _buildSlider('Peg Spacing', pegSpacing, 25, 35, (value) {
                      modalSetState(() {
                        pegSpacing = value;
                        _initializePegs();
                      });
                    }),
                    _buildSlider('Rows', rows.toDouble(), 12, 20, (value) {
                      modalSetState(() {
                        rows = value.toInt();
                        _initializePegs();
                      });
                    }),
                    _buildSlider('Initial X Velocity Range',
                        initialXVelocityRange, 0.1, 5, (value) {
                      modalSetState(() {
                        initialXVelocityRange = value;
                      });
                    }),
                    _buildSlider('Initial X Position Range',
                        initialXPositionRange, 0.1, 2, (value) {
                      modalSetState(() {
                        initialXPositionRange = value;
                      });
                    }),
                    _buildSlider('X Acceleration', x_acceleration, 0.1, 2,
                        (value) {
                      modalSetState(() {
                        x_acceleration = value;
                      });
                    }),
                    _buildSlider('Y Acceleration', y_acceleration, 0.1, 10,
                        (value) {
                      modalSetState(() {
                        y_acceleration = value;
                      });
                    }),
                    _buildSlider(
                        'Base Y Acceleration', base_y_acceleration, 0.1, 3,
                        (value) {
                      modalSetState(() {
                        base_y_acceleration = value;
                      });
                    }),
                    _buildSlider('Catch Distance', catch_distance, 1, 20,
                        (value) {
                      modalSetState(() {
                        catch_distance = value;
                      });
                    }),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSlider(String label, double value, double min, double max,
      ValueChanged<double> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Slider(
          value: value,
          min: min,
          max: max,
          divisions: 100,
          label: value.toStringAsFixed(2),
          onChanged: onChanged,
          onChangeEnd: (value) {
            _startBallDrop();
          },
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          if (!widget.squeezed)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                  height: 50.sw,
                  width: columnWidth,
                  margin: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return GestureDetector(
                                  onHorizontalDragUpdate: (details) {
                                    setState(() {
                                      dragPosition += details.delta.dx;
                                      if (dragPosition < 0) {
                                        dragPosition = 0;
                                      } else if (dragPosition >
                                          autoSliderWidth / 2) {
                                        dragPosition = autoSliderWidth / 2;
                                      }
                                      isManual =
                                          dragPosition < autoSliderWidth / 4;
                                    });
                                  },
                                  onHorizontalDragEnd: (details) {
                                    setState(() {
                                      dragPosition =
                                          isManual ? 0 : autoSliderWidth / 2;
                                    });
                                  },
                                  onTapUp: (details) {
                                    setState(() {
                                      if (details.localPosition.dx <
                                          autoSliderWidth / 2) {
                                        dragPosition = 0;
                                        isManual = true;
                                      } else {
                                        dragPosition = autoSliderWidth / 2;
                                        isManual = false;
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: buttonsHeight,
                                    width: autoSliderWidth,
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.35),
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: autoSliderMargin,
                                          child: Container(
                                            width: autoSliderWidth / 2 -
                                                autoSliderMargin * 2,
                                            height: buttonsHeight -
                                                autoSliderMargin * 2,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text('Manual',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        Positioned(
                                          top: autoSliderMargin,
                                          left: autoSliderWidth / 2,
                                          child: Container(
                                            width: autoSliderWidth / 2 -
                                                autoSliderMargin * 2,
                                            height: buttonsHeight -
                                                autoSliderMargin * 2,
                                            decoration: BoxDecoration(
                                              color:
                                                  Colors.black.withOpacity(0),
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            alignment: Alignment.center,
                                            child: const Text('Auto',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                        Positioned(
                                          left: dragPosition + autoSliderMargin,
                                          top: autoSliderMargin,
                                          child: Container(
                                            width: autoSliderWidth / 2 -
                                                autoSliderMargin * 2,
                                            height: buttonsHeight -
                                                autoSliderMargin * 2,
                                            decoration: BoxDecoration(
                                              color: const Color(0xffff97dd),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              gradient: const LinearGradient(
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter,
                                                colors: [
                                                  Color(0xffff9cd9),
                                                  Color(0xFFFF80CF),
                                                ],
                                              ),
                                            ),
                                            alignment: Alignment.center,
                                            child: Text(
                                                isManual ? 'Manual' : 'Auto',
                                                style: TextStyle(
                                                    fontSize: 17,
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    fontWeight:
                                                        FontWeight.bold)),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Container(
                          width: horizontalSpacingWidth,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: BackdropFilter(
                            filter:
                                ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                            child: GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              onTap: () {
                                setState(() {
                                  if (riskText == 'High') {
                                    riskText = 'Low';
                                    ristIcon = Icons.air;
                                  } else if (riskText == 'Med') {
                                    riskText = 'High';
                                    ristIcon = Icons.whatshot_rounded;
                                  } else {
                                    riskText = 'Med';
                                    ristIcon = Icons.flash_on;
                                  }
                                });
                              },
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  final offsetAnimation = Tween<Offset>(
                                    begin: child.key == ValueKey(riskText)
                                        ? Offset(0.0, 1.0)
                                        : Offset(0.0, -1.0),
                                    end: Offset(0.0, 0.0),
                                  ).animate(animation);
                                  return ClipRect(
                                    child: SlideTransition(
                                      position: offsetAnimation,
                                      child: child,
                                    ),
                                  );
                                },
                                child: Container(
                                  color: Colors.black.withOpacity(0.35),
                                  key: ValueKey<String>(riskText),
                                  height: buttonsHeight,
                                  width: 100,
                                  alignment: Alignment.centerLeft,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              riskText,
                                              style: const TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 0),
                                            child: Text(
                                              "Risk",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Icon(ristIcon,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 30),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ]),
                      Container(height: horizontalSpacingWidth),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  widget.setBackgroundPage('signup1');
                                  widget.squeeze();
                                },
                                child: Container(
                                  width: 280,
                                  height: buttonsHeight,
                                  decoration: BoxDecoration(
                                    color: Color.fromRGBO(60, 60, 60, 0.5),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.5),
                                        spreadRadius: 3,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      Container(width: 15),
                                      Icon(ristIcon,
                                          color: Colors.white.withOpacity(0.5),
                                          size: 30),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Not signed in",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Text(
                                              "Balance: 0.00",
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white
                                                      .withOpacity(0.5)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(width: horizontalSpacingWidth),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  _showSettingsPopup();
                                },
                                child: Container(
                                  width: 60,
                                  height: buttonsHeight,
                                  color: Colors.black.withOpacity(0.35),
                                  child: Center(
                                    child: Icon(Icons.login,
                                        color: Colors.white.withOpacity(0.5),
                                        size: 30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Container(height: horizontalSpacingWidth),
                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10.0),
                            child: BackdropFilter(
                              filter:
                                  ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: _startBallDrop,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Color(0xffff97dd),
                                      borderRadius: BorderRadius.circular(15),
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Color(0xffff9cd9),
                                          Color(0xFFFF80CF),
                                        ],
                                      ),
                                    ),
                                    width: columnWidth,
                                    height: buttonsHeight,
                                    child: Center(
                                      child: Text("Bet",
                                          style: TextStyle(
                                              fontSize: 20,
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )),
            ),
          Align(
            alignment: Alignment(0, -0.4),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  mainAxisAlignment: constraints.maxHeight < 300
                      ? MainAxisAlignment.center
                      : MainAxisAlignment.start,
                  children: constraints.maxHeight < 300
                      ? [
                          Container(
                              height: reducedMainScreenHeight - 20,
                              width: reducedMainScreenWidth - 20,
                              margin: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                      sigmaX: 10.0, sigmaY: 10.0),
                                  child: Container(
                                    color: Color.fromRGBO(191, 107, 171, 0.6),
                                    child: Center(
                                      child: Text("Back to Plinko",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                ),
                              ))
                        ]
                      : [
                          Container(
                            height: 25,
                            width: columnWidth,
                            margin: const EdgeInsets.all(8.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(
                                    sigmaX: 10.0, sigmaY: 10.0),
                                child: Container(
                                    color: Color.fromRGBO(191, 107, 171, 0.6),
                                    child: DefaultTextStyle(
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white.withOpacity(0.5)),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text('FAQ'),
                                          Text('How to play'),
                                          Text('T&C'),
                                          Text('AML'),
                                          Text('KYC'),
                                          Text('Responsible Gaming'),
                                        ],
                                      ),
                                    )),
                              ),
                            ),
                          ),
                          Container(
                              width: columnWidth + 10,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                          sigmaX: 10.0, sigmaY: 10.0),
                                      child: Container(
                                          height: MediaQuery.sizeOf(context)
                                                  .height -
                                              columnWidth +
                                              30,
                                          width: columnWidth,
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(
                                                191, 107, 171, 0.6),
                                          ),
                                          child: Stack(
                                            children: [
                                              Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        GestureDetector(
                                                          onTap: () {
                                                            widget
                                                                .setBackgroundPage(
                                                                    'music');
                                                            widget.squeeze();
                                                          },
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15.0),
                                                              color: Color(
                                                                      0xff9f379a)
                                                                  .withOpacity(
                                                                      0.6),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 1,
                                                                  offset:
                                                                      Offset(
                                                                          0, 1),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                                Icons
                                                                    .music_note,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                        GestureDetector(
                                                          onTap: () {
                                                            widget
                                                                .setBackgroundPage(
                                                                    'chat');
                                                            widget.squeeze();
                                                          },
                                                          child: Container(
                                                            height: 50,
                                                            width: 50,
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          10.0),
                                                              color: Color(
                                                                      0xff9f379a)
                                                                  .withOpacity(
                                                                      0.4),
                                                              boxShadow: [
                                                                BoxShadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                          0.2),
                                                                  spreadRadius:
                                                                      1,
                                                                  blurRadius: 1,
                                                                  offset:
                                                                      Offset(
                                                                          0, 1),
                                                                ),
                                                              ],
                                                            ),
                                                            child: Icon(
                                                                Icons.chat,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                              ...pegs.map((peg) => Positioned(
                                                    left: peg.dx,
                                                    top: peg.dy,
                                                    child: Container(
                                                      width: 7,
                                                      height: 7,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
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
                                                      decoration: BoxDecoration(
                                                        color: Colors.black,
                                                        shape: BoxShape.circle,
                                                      ),
                                                    ),
                                                  )),
                                              ...multipliers
                                                  .map(
                                                      (multiplier) =>
                                                          Positioned(
                                                            left: (columnWidth /
                                                                        multipliers
                                                                            .length) *
                                                                    multiplier
                                                                        .position +
                                                                1,
                                                            top: multipliersY,
                                                            child: Container(
                                                              width: ((columnWidth -
                                                                          5) /
                                                                      multipliers
                                                                          .length) -
                                                                  2,
                                                              height: 35,
                                                              decoration: BoxDecoration(
                                                                  color: adjustColorBrightness(
                                                                      Color(
                                                                          0xffff97dd),
                                                                      ((columnWidth / multipliers.length) * multiplier.position + 0.5 * (columnWidth / multipliers.length) - 0.5 * columnWidth)
                                                                              .abs() /
                                                                          (columnWidth /
                                                                              2)),
                                                                  shape: BoxShape
                                                                      .rectangle,
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              10))),
                                                              child: Center(
                                                                child: Text(
                                                                  '${multiplier.value}x',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                              ),
                                                            ),
                                                          )),
                                            ],
                                          ))))),
                          if (false)
                            Container(
                              margin: const EdgeInsets.all(8.0),
                              child: Text(
                                'Score: $score',
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                        ],
                );
              },
            ),
          ),
        ],
      ),
    );
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
