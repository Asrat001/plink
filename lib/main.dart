import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:plinko/config/routing.dart';
import 'package:responsive_builder/responsive_builder.dart';

import 'bloc/auth/auth_bloc.dart';
import 'config/theme.dart';

void main() async {
  // await dotenv.load(fileName: ".env");
  runApp(
    DevicePreview(
      enabled: false,
      builder: (_) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(),
        ),
      ],
      child: ResponsiveApp(
        builder: (context) {
          return MaterialApp.router(
            title: 'Plink',
            theme: themeData(context),
            debugShowCheckedModeBanner: false,
            routerConfig: goRouter,
          );
        },
      ),
    );
  }
}
