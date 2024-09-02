import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/bloc/auth/auth_bloc.dart';
import 'package:plinko/config/routing.dart';
import 'package:plinko/presentation/screens/login_screen/components/add_to_home_screen_bottomsheet.dart';
import 'package:plinko/presentation/widgets/button_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '/presentation/widgets/container_widget.dart';

class DepositBounus extends StatefulWidget {
  const DepositBounus({super.key,});

  @override
  State<DepositBounus> createState() => _DepositBounusState();
}

class _DepositBounusState extends State<DepositBounus> {
  int selectedIndex = 0;

  @override
  void initState() {
    log('login');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 100.sh,
        child: Stack(
          children: [
            Container(
              height: 100.sh,
              width: 100.sh,
              child: Image(image: AssetImage("assets/images/Viewport.png"),fit: BoxFit.fill,),
            ),
            _buildEmailDisplay(),
          ],
        ),
      ),
    );
  }

  _buildEmailDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Visibility(
        visible: selectedIndex == 0,
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Image(image: AssetImage("assets/images/DepositBonus.png"),height: 100,),
            const SizedBox(height: 20),
            Text(
              'You won 150% deposit\nbonus',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                fontSize: 27,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 150),
            Text(
              'Register with your email to use it',
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 7),
            const ContainerWidget(
              child: TextField(
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    hintText: 'your.email@provider.com',
                    hintStyle: TextStyle(
                      color: Colors.white38,
                        fontSize: 17,
                        fontWeight: FontWeight.w400
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    border: InputBorder.none,
                  )),
            ),
            const Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: ButtonWidget(
                width: 100.sh,
                gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFFA7DE),
                      Color(0xFFFF77CC),
                    ]),
                height: 48,
                child: Center(
                    child: Text(
                      'Continue',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontSize: 19,
                        color: const Color(0xFF61003C),
                      ),
                    )),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    // context.pushNamed(RouteName.chatScreen);
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}