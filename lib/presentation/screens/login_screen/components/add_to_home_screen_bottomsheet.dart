import 'package:flutter/material.dart';
import 'package:plinko/gen/assets.gen.dart';
import 'package:responsive_builder/responsive_builder.dart';

class AddToHomeScreenBottomSheet extends StatelessWidget {
  const AddToHomeScreenBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.sw,
      height: 350,
      color: const Color(0xFF403740),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: const Color(0xFFFF80CF),
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'Add to your\nhome screen to play',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 27,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 15),
            Text(
              'You must do this from the sharing menu in Safari in order to play Plinko',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontSize: 15,
                    color: const Color(0xFFCBB2CB),
                  ),
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Tap  ',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                ),
                Assets.images.homeIcon.image(
                  color: Colors.white,
                ),
                Text(
                  ' ,then tap “Add on the home screen”',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 15,
                        color: Colors.white,
                      ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
