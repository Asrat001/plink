import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:plinko/data/models/wallet_model.dart';
import 'package:plinko/presentation/screens/music_screen/music_screen.dart';
import 'package:plinko/presentation/screens/wallet_screen/components/wallet_detail.dart';

import '../presentation/screens/home_screen/components/deposit_bonusScreen.dart';
import '../presentation/screens/home_screen/home_screen.dart';

class RouteName {
  static const homeScreen = 'home_screen';
  static const musicScreen = 'music_screen';
  static const walletDetail = 'wallet_detail';
  static const bonusScreen = 'deposit_bonus';
}

Page<void> _fadeTransitionPageBuilder(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

final goRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: RouteName.homeScreen,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/music',
      name: RouteName.musicScreen,
      builder: (context, state) => const MusicScreen(),
    ),
    GoRoute(
      path: '/wallet_detail',
      name: RouteName.walletDetail,
      pageBuilder: (context, state) => _fadeTransitionPageBuilder(
        context,
        state,
        WalletDetail(
          walletModel: state.extra as WalletModel,
        ), // Your DetailsPage widget
      ),
    ),
    GoRoute(
      path: '/deposit_bonus',
      name: RouteName.bonusScreen,
      builder: (context, state) => const DepositBounus(),
    ),

  ],
);
