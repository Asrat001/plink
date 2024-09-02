import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:marquee_text/marquee_text.dart';
import 'package:plinko/core/utils/responsive_util.dart';
import 'package:responsive_builder/responsive_builder.dart';
import '../../../data/models/music_model.dart';
import '../../../gen/colors.gen.dart';
import 'components/music_visualizer.dart';

/// The home screen of the music player application.
///
/// This screen displays the main UI elements, including the music title,
/// artist, visualizer, audio controls, and sound controls.
class MusicScreen extends StatefulWidget {
  /// Creates a new instance of the `HomeScreen` widget.
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

/// The state for the `HomeScreen` widget.
///
/// This state manages the music playback, visualizer animation, and UI updates.
class _MusicScreenState extends State<MusicScreen> {
  /// The current sound level, ranging from 0 to 100.
  double soundLevel = 80;

  /// The index of the currently playing music track.
  int currentMusicIndex = 0;

  /// The `AssetsAudioPlayer` instance used for music playback.
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  /// A flag indicating whether this is the first time playing a track.
  bool isFirstTime = true;

  /// A flag indicating whether music is currently playing.
  bool isPlaying = false;

  /// The duration of the current music track.
  Duration duration = Duration.zero;

  /// The current position in the music track.
  Duration position = Duration.zero;

  @override
  void initState() {
    /// Listen for the playlist finished event.
    assetsAudioPlayer.playlistFinished.listen((isFinished) {
      if (isFinished) {
        if (mounted) {
          setState(() {
            /// Stop playback and reset the first time flag.
            isPlaying = false;
            isFirstTime = true;

            /// Move to the next track or loop back to the beginning.
            currentMusicIndex == 2
                ? currentMusicIndex = 0
                : currentMusicIndex = currentMusicIndex + 1;
          });
        }

        /// Start playing the next track.
        playButtonHandler();
      }
    });

    /// Listen for changes in the current position of the music track.
    assetsAudioPlayer.currentPosition.listen((p) {
      if (mounted) {
        setState(() {
          position = p;
        });
      }
    });

    /// Listen for changes in the current audio metadata.
    assetsAudioPlayer.current.listen((d) {
      if (mounted) {
        setState(() {
          duration = d?.audio.duration ?? Duration.zero;
        });
      }
    });

    super.initState();
  }

  /// Handles the play/pause button press.
  ///
  /// This method toggles the playback state and updates the UI accordingly.
  playButtonHandler() async {
    if (assetsAudioPlayer.isPlaying.value) {
      /// Pause playback if music is currently playing.
      await assetsAudioPlayer.pause();
      if (mounted) {
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      /// If this is the first time playing a track, open the track and start playback.
      if (isFirstTime) {
        await assetsAudioPlayer.open(
          Audio.network(musicList[currentMusicIndex].path,
              metas: Metas(
                title: musicList[currentMusicIndex].title,
                artist: musicList[currentMusicIndex].artist,
              )),
        );
        isFirstTime = false;
      } else {
        /// Resume playback if music is paused.
        await assetsAudioPlayer.play();
      }
      if (mounted) {
        setState(() {
          isPlaying = true;
        });
      }
    }
    // ignore: use_build_context_synchronously
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.backgroundColor,
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        alignment: Alignment.center,
        child: _buildMainUI(),
      ),
    );
  }

  /// Builds the main UI of the home screen.
  ///
  /// This method creates a container with the main UI elements, including
  /// the header, back button, music title, visualizer, audio controls, and
  /// sound controls.
  _buildMainUI() {
    return ScreenTypeLayout.builder(
        breakpoints:
            const ScreenBreakpoints(desktop: 1600, tablet: 1200, watch: 500),
        watch: (_) => Container(
              alignment: Alignment.center,

              /// Set the width and height of the container.
              width: 100.sw,

              height: 100.sh,

              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),

              /// Apply a background color and rounded corners.
              decoration: const BoxDecoration(
                color: ColorName.backgroundColor,
              ),

              /// Arrange the UI elements in a column.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 90),
                  _buildMusicTitle(),
                  _buildSoundSynchronization(),
                  _buildAudioControllers(),
                  const Expanded(child: SizedBox()),
                  _buildSoundControllers(),
                ],
              ),
            ),
        mobile: (_) => Container(
              alignment: Alignment.center,

              /// Set the width and height of the container.
              width: 95.sw,

              height: 100.sh,

              /// Add margins and padding for spacing.
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              padding: const EdgeInsets.all(50),

              /// Apply a background color and rounded corners.
              decoration: BoxDecoration(
                color: ColorName.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),

              /// Arrange the UI elements in a column.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 90),
                  _buildMusicTitle(),
                  // _buildSoundSynchronization(),
                  _buildAudioControllers(),
                  const Expanded(child: SizedBox()),
                  _buildSoundControllers(),
                ],
              ),
            ),
        tablet: (_) => Container(
              alignment: Alignment.center,

              /// Set the width and height of the container.
              width: 70.sw,

              height: 100.sh,
              padding: const EdgeInsets.all(16),

              /// Add margins and padding for spacing.

              /// Apply a background color and rounded corners.
              decoration: BoxDecoration(
                color: ColorName.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),

              /// Arrange the UI elements in a column.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 90),
                  _buildMusicTitle(),
                  // _buildSoundSynchronization(),
                  _buildAudioControllers(),
                  const Expanded(child: SizedBox()),
                  _buildSoundControllers(),
                ],
              ),
            ),
        desktop: (_) => Container(
              alignment: Alignment.center,

              /// Set the width and height of the container.
              width: 30.sh,

              height: 100.sw,

              /// Add margins and padding for spacing.
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.all(16),

              /// Apply a background color and rounded corners.
              decoration: BoxDecoration(
                color: ColorName.backgroundColor,
                borderRadius: BorderRadius.circular(20),
              ),

              /// Arrange the UI elements in a column.
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 90),
                  _buildMusicTitle(),
                  // _buildSoundSynchronization(),
                  _buildAudioControllers(),
                  const Expanded(child: SizedBox()),
                  _buildSoundControllers(),
                ],
              ),
            ));
  }

  /// Builds the header of the home screen.
  ///
  /// This method creates a row with the title "Music" and the number of
  /// online tracks.
  _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        /// Display the title "Music".
        Text(
          'Music',
          style: Theme.of(context).textTheme.titleMedium!.copyWith(
                fontSize: 21,
              ),
        ),

        /// Display the number of online tracks.
        RichText(
          text: TextSpan(
            text: '237 ',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 16,
                ),
            children: [
              TextSpan(
                  text: ' Online',
                  style: TextStyle(
                    color: ColorName.lightPink.withOpacity(0.7),
                  ))
            ],
          ),
        )
      ],
    );
  }

  /// Builds the music title and artist display.
  ///
  /// This method creates a column with the music title and artist, using
  /// a marquee text widget for the title to scroll if it's too long.
  _buildMusicTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Display the music title using a marquee text widget.
        MarqueeText(
          speed: 25,
          text: TextSpan(
            text: musicList[currentMusicIndex].title,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 27,
                ),
          ),
        ),

        /// Add a small space between the title and artist.
        const SizedBox(height: 5),

        /// Display the artist name.
        Text(
          musicList[currentMusicIndex].artist,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(
                color: ColorName.lightPink.withOpacity(0.7),
                fontSize: 15,
              ),
        )
      ],
    );
  }

  /// Builds the sound synchronization section.
  ///
  /// This method creates a container with a visualizer that animates based
  /// on the music playback state.
  _buildSoundSynchronization() {
    return ResponsiveBuilder(builder: (context, sizingInfo) {
      return Container(
        /// Set the width and height of the container.
        width: 100.sh,
        height: ResponsiveUtil.forScreen(
          sizingInfo: sizingInfo,
          small: 220,
          mobile: 300,
          tablet: 300,
          desktop: 300,
          large: 300,
        ),

        /// Add margins and padding for spacing.
        margin: const EdgeInsets.symmetric(vertical: 30),
        padding: const EdgeInsets.all(15),

        /// Apply a background color and rounded corners.
        decoration: BoxDecoration(
          color: ColorName.foregroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05), width: 2),
        ),

        /// Align the visualizer to the bottom center of the container.
        child: Align(
          alignment: Alignment.bottomCenter,
          child: MusicVisualizer(
            /// Pass the current playback state to the visualizer.
            isPlaying: isPlaying,
          ),
        ),
      );
    });
  }

  /// Builds the audio controls.
  ///
  /// This method creates a row with buttons for rewinding, playing/pausing,
  /// and fast-forwarding the music track.
  _buildAudioControllers() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: ScreenTypeLayout.builder(
        breakpoints:
            const ScreenBreakpoints(desktop: 1600, tablet: 1200, watch: 500),
        watch: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Rewind button.
            SizedBox(
              width: 120,
              height: 65,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    /// Seek to 10 seconds before the current position.
                    final to = position.inSeconds - 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_rewind,
                    size: 35,
                    color: ColorName.white,
                  )),
            ),

            /// Play/pause button.
            SizedBox(
              width: 120,
              height: 65,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: ColorName.white.withOpacity(0.2),
                      width: 2,
                    ),
                    backgroundColor: const Color.fromARGB(255, 250, 114, 198),
                    shadowColor: ColorName.white.withOpacity(0.1),
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: playButtonHandler,
                  child: Icon(
                    /// Display the pause icon if music is playing, otherwise display the play icon.
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 35,
                    color: const Color(0xFF5C0039),
                  )),
            ),

            /// Fast-forward button.
            SizedBox(
              width: 120,
              height: 65,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    /// Seek to 10 seconds after the current position.
                    final to = position.inSeconds + 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_forward,
                    size: 35,
                    color: ColorName.white,
                  )),
            )
          ],
        ),
        mobile: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Rewind button.
            SizedBox(
              width: 120,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    /// Seek to 10 seconds before the current position.
                    final to = position.inSeconds - 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_rewind,
                    size: 30,
                    color: ColorName.white,
                  )),
            ),

            /// Play/pause button.
            SizedBox(
              width: 100,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: ColorName.white.withOpacity(0.2),
                      width: 2,
                    ),
                    backgroundColor: const Color.fromARGB(255, 250, 114, 198),
                    shadowColor: ColorName.white.withOpacity(0.1),
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: playButtonHandler,
                  child: Icon(
                    /// Display the pause icon if music is playing, otherwise display the play icon.
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 30,
                    color: const Color(0xFF5C0039),
                  )),
            ),

            /// Fast-forward button.
            SizedBox(
              width: 100,
              height: 60,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    /// Seek to 10 seconds after the current position.
                    final to = position.inSeconds + 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_forward,
                    size: 30,
                    color: ColorName.white,
                  )),
            )
          ],
        ),
        tablet: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Rewind button.
            SizedBox(
              width: 120,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    /// Seek to 10 seconds before the current position.
                    final to = position.inSeconds - 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_rewind,
                    size: 50,
                    color: ColorName.white,
                  )),
            ),

            /// Play/pause button.
            SizedBox(
              width: 120,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: ColorName.white.withOpacity(0.2),
                      width: 2,
                    ),
                    backgroundColor: const Color.fromARGB(255, 250, 114, 198),
                    shadowColor: ColorName.white.withOpacity(0.1),
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: playButtonHandler,
                  child: Icon(
                    /// Display the pause icon if music is playing, otherwise display the play icon.
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 50,
                    color: const Color(0xFF5C0039),
                  )),
            ),

            /// Fast-forward button.
            SizedBox(
              width: 120,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    /// Seek to 10 seconds after the current position.
                    final to = position.inSeconds + 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_forward,
                    size: 50,
                    color: ColorName.white,
                  )),
            )
          ],
        ),
        desktop: (_) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Rewind button.
            SizedBox(
              width: 8.sh,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(100),
                        bottomLeft: Radius.circular(100),
                        topRight: Radius.circular(30),
                        bottomRight: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () {
                    /// Seek to 10 seconds before the current position.
                    final to = position.inSeconds - 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_rewind,
                    size: 50,
                    color: ColorName.white,
                  )),
            ),

            /// Play/pause button.
            SizedBox(
              width: 8.sh,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: ColorName.white.withOpacity(0.2),
                      width: 2,
                    ),
                    backgroundColor: const Color.fromARGB(255, 250, 114, 198),
                    shadowColor: ColorName.white.withOpacity(0.1),
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: playButtonHandler,
                  child: Icon(
                    /// Display the pause icon if music is playing, otherwise display the play icon.
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    size: 50,
                    color: const Color(0xFF5C0039),
                  )),
            ),

            /// Fast-forward button.
            SizedBox(
              width: 8.sh,
              height: 70,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shadowColor: ColorName.lightPink.withOpacity(0.2),
                    backgroundColor: ColorName.foregroundColor,
                    elevation: 40,
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        color: ColorName.lightPink.withOpacity(0.05),
                        width: 2,
                      ),
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(100),
                        bottomRight: Radius.circular(100),
                        topLeft: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                      ),
                    ),
                  ),
                  onPressed: () async {
                    /// Seek to 10 seconds after the current position.
                    final to = position.inSeconds + 10;
                    assetsAudioPlayer.seek(Duration(
                      seconds: to,
                    ));
                  },
                  child: const Icon(
                    Icons.fast_forward,
                    size: 50,
                    color: ColorName.white,
                  )),
            )
          ],
        ),
      ),
    );
  }

  /// Builds the sound controls.
  ///
  /// This method creates a row with buttons for muting, adjusting the volume,
  /// and unmuting the sound.
  _buildSoundControllers() {
    return Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// Mute button.
          IconButton(
            onPressed: () {
              /// Decrease the volume by 10 if possible, otherwise set it to 0.W
              if ((soundLevel - 10) >= 0) {
                if (mounted) {
                  setState(() {
                    soundLevel -= 10;
                  });
                }
              } else {
                if (mounted) {
                  setState(() {
                    soundLevel = 0;
                  });
                }
              }

              /// Update the volume of the music player.
              assetsAudioPlayer.setVolume((soundLevel / 100));
            },
            icon: const Icon(
              Icons.volume_mute,
              size: 35,
              color: ColorName.lightPink,
            ),
          ),

          /// Volume slider.
          SizedBox(
            width: 220,
            child: Slider(
              /// Set the initial value of the slider to the current sound level.
              value: soundLevel,

              /// Set the maximum value of the slider to the duration of the music track.
              max: 100,
              onChanged: (value) async {
                if (mounted) {
                  setState(() {
                    soundLevel = value;
                  });
                }

                assetsAudioPlayer.setVolume((value / 100));
              },
            ),
          ),

          /// Unmute button.
          IconButton(
            onPressed: () {
              /// Increase the volume by 10 if possible, otherwise set it to 100.
              if ((soundLevel + 10) <= 100) {
                if (mounted) {
                  setState(() {
                    soundLevel += 10;
                  });
                }
              } else {
                if (mounted) {
                  setState(() {
                    soundLevel = 100;
                  });
                }
              }

              /// Update the volume of the music player.
              assetsAudioPlayer.setVolume((soundLevel / 100));
            },
            icon: const Icon(
              Icons.volume_up,
              size: 35,
              color: ColorName.lightPink,
            ),
          )
        ],
      ),
    );
  }
}

