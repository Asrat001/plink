import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plinko/gen/fonts.gen.dart';

import '../gen/colors.gen.dart';

// ThemeData themeData(BuildContext context) {
//   return ThemeData(
//     textTheme: GoogleFonts.interTextTheme(
//       // Set default text theme to Inter
//       Theme.of(context).textTheme,
//     ),
//     colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//     useMaterial3: true,
//   );
// }

/// Creates the theme data for the music player application.
///
/// This function defines the overall theme of the application, including
/// colors, typography, and other visual elements.
ThemeData themeData(BuildContext context) {
  return ThemeData(
    /// Sets the background color of the scaffold (main content area).
    scaffoldBackgroundColor: ColorName.backgroundColor,

    /// Sets the color scheme seed, which is used to generate the color scheme.
    colorSchemeSeed: ColorName.primaryColor,

    fontFamily: FontFamily.interVariable,

    /// Customizes the slider theme.
    sliderTheme: SliderThemeData(
      /// Sets the height of the slider track.
      trackHeight: 10,

      /// Disables the display of the value indicator.
      showValueIndicator: ShowValueIndicator.never,

      /// Removes the thumb shape from the slider.
      thumbShape: SliderComponentShape.noThumb,

      /// Sets the color of the active track.
      activeTrackColor: const Color(0xFFCF98BB),

      /// Sets the color of the inactive track.
      inactiveTrackColor: ColorName.foregroundColor,

      /// Sets the color of the disabled active track.
      disabledActiveTrackColor: ColorName.primaryColor,
    ),

    popupMenuTheme: PopupMenuThemeData(
      color: const Color(0xFF964D89),
      elevation: 10,

      // surfaceTintColor: const Color(0xFF93517C),
      shadowColor: Colors.black.withOpacity(0.2),
      position: PopupMenuPosition.under,

      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(16),
      ),
    ),

    /// Customizes the text theme.
    textTheme: GoogleFonts.interTextTheme(
      Theme.of(context).textTheme.copyWith(
            /// Defines the style for the `titleMedium` text style.
            titleMedium: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w500,
              color: ColorName.white,
            ),

            /// Defines the style for the `titleSmall` text style.
            titleSmall: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              color: ColorName.white,
            ),

            /// Defines the style for the `titleLarge` text style.
            titleLarge: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              color: ColorName.white,
            ),
          ),
    ),
  );
}
