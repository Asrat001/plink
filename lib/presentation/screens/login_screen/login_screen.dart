import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko/bloc/auth/auth_bloc.dart';
import 'package:plinko/presentation/screens/login_screen/components/add_to_home_screen_bottomsheet.dart';
import 'package:plinko/presentation/widgets/button_widget.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '/presentation/widgets/container_widget.dart';

class LoginScreen extends StatefulWidget {
  final Function() squeeze;
  final Function(String) setBackground;
  const LoginScreen(
      {super.key, required this.squeeze, required this.setBackground});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Stack(
          children: [
            _buildEmailDisplay(),
            _buildCreatePassoword(),
          ],
        ),
      ),
    );
  }

  _buildEmailDisplay() {
    return Visibility(
      visible: selectedIndex == 0,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Welcome to Plinko',
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 27,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 5),
          Text(
            'Enter your Email to start playing',
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontSize: 15, color: const Color(0xFFCCB3CC)),
          ),
          const SizedBox(height: 150),
          Text(
            'Your Email',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 15,
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
                    color: Colors.white70,
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
                  selectedIndex = 1;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  _buildCreatePassoword() {
    return Visibility(
      visible: selectedIndex == 1,
      child: Column(
        children: [
          const SizedBox(height: 100),
          Text(
            'Welcome,\njoey@email.com',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontSize: 27,
                  color: Colors.white,
                ),
          ),
          const SizedBox(height: 150),
          Text(
            'Enter your password',
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  fontSize: 15,
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
                  hintText: '*****************',
                  hintStyle: TextStyle(
                    color: Colors.white70,
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
            child: Row(
              children: [
                selectedIndex == 1
                    ? Expanded(
                        flex: 3,
                        child: ButtonWidget(
                          height: 48,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.arrow_back_ios,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 10),
                              Text(
                                'Back',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall!
                                    .copyWith(
                                      fontSize: 19,
                                    ),
                              ),
                            ],
                          ),
                          onPressed: () {
                            setState(() {
                              selectedIndex = 0;
                            });
                          },
                        ),
                      )
                    : const SizedBox.shrink(),
                const SizedBox(width: 15),
                Expanded(
                  flex: 5,
                  child: ButtonWidget(
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
                      'Start Playing',
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontSize: 19,
                            color: const Color(0xFF61003C),
                          ),
                    )),
                    onPressed: () {
                      context.read<AuthBloc>().add(
                            ChangeLogginStatus(isLoggedIn: true),
                          );
                      widget.setBackground('');
                      widget.setBackground('wallet');
                      widget.squeeze();

                      showModalBottomSheet(
                        context: context,
                        builder: (_) => const AddToHomeScreenBottomSheet(),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
