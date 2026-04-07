import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/screen/auth/login_screen.dart';
import 'package:mobile_app/screen/auth/register_screen.dart';
import 'package:mobile_app/screen/home_screen.dart';
import 'package:mobile_app/screen/leaderboard_screen.dart';
import 'package:mobile_app/screen/settings_screen.dart';
import 'package:mobile_app/main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _leaderBoardNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/login',
  refreshListenable: authService,
  redirect: (context, state) {
    if (!authService.isReady) return null;

    final isLoggedIn = authService.isLoggedIn;
    final path = state.uri.path;
    final isAuthPage = path == '/login' || path == '/register';

    if (!isLoggedIn && !isAuthPage) return '/login';
    if (isLoggedIn && isAuthPage) return '/home';

    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const SettingsScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          navigatorKey: _homeNavigatorKey,
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _leaderBoardNavigatorKey,
          routes: [
            GoRoute(
              path: '/leaderboard',
              builder: (context, state) => const LeaderBoardScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
