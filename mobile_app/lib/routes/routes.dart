import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/screen/home_screen.dart';
import 'package:mobile_app/main_scaffold.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _homeNavigatorKey = GlobalKey<NavigatorState>();
final _leaderBoardNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  redirect: (context, state) {
    if (state.uri.path == '/') {
      return '/home';
    }
    return null;
  },  
  routes: [
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
              routes: [
                // GoRoute(
                //   path: 'details',
                //   builder: (context, state) => const HomeDetailsPage(),
                // ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          navigatorKey: _leaderBoardNavigatorKey,
          routes: [
            GoRoute(
              path: '/leaderboard',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Leaderboard'))),
            ),
          ],
        ),
        // StatefulShellBranch(
        //   navigatorKey: _searchNavigatorKey,
        //   routes: [
        //     GoRoute(
        //       path: '/search',
        //       builder: (context, state) => const SearchPage(),
        //     ),
        //   ],
        // ),
        // StatefulShellBranch(
        //   navigatorKey: _profileNavigatorKey,
        //   routes: [
        //     GoRoute(
        //       path: '/profile',
        //       builder: (context, state) => const ProfilePage(),
        //     ),
        //   ],
        // ),
      ],
    ),
  ],
);
