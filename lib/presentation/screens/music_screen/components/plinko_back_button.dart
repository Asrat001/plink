import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_builder/responsive_builder.dart';

/// A custom back button widget that resembles the classic Plinko game.
///
/// This widget uses a stack of positioned dots to create the visual effect of
/// Plinko pegs. The text "Back to Plinko" is centered on the button and is
/// tappable.
class PlinkoBackButton extends StatelessWidget {
  final double reducedMainScreenHeight;

  /// Creates a new instance of the `PlinkoBackButton` widget.
  const PlinkoBackButton({super.key, required this.reducedMainScreenHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.symmetric(vertical: 30),
      margin: const EdgeInsets.only(top: 5, bottom: 5),
      height: reducedMainScreenHeight,
      width: 100.sh,
      decoration: BoxDecoration(
        color: const Color(0x008A498A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        children: [
          Positioned(
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
              child: Align(
                child: Text(
                  'Back to Plinko',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 23,
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ))
        ],
      ),
    );
  }

  /// A helper function to build a single Plinko dot.
  ///
  /// This function takes the color of the dot and optional positioning
  /// parameters as input.
  _buildDot({
    required Color color,
    double? top,
    double? left,
    double? right,
    double? bottom,
    required BuildContext context,
  }) {
    return Positioned(
      top: top,
      left: left,
      right: right,
      bottom: bottom,
      child: InkWell(
        onTap: () {
          context.pop();
        },
        child: Align(
          child: Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
      ),
    );
  }
}
