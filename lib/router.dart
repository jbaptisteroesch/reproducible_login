import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:reproducible_login/homepage.dart';
import 'package:reproducible_login/login_screen.dart';

import 'auth.dart';

const String loginRouteName = 'login';
const String homepageRouteName = 'home';
const String loginRoutePath = '/login';
const String homepageRoutePath = '/';

class MyRouter {
  MyRouter(this.loginState);

  /// The login state of the user.
  final AuthModel loginState;

  late final GoRouter router = GoRouter(
    refreshListenable: loginState,
    //debugLogDiagnostics: true,
    routerNeglect: true,
    routes: <GoRoute>[
      GoRoute(
        path: homepageRoutePath,
        name: homepageRouteName,
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: loginRoutePath,
        name: loginRouteName,
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
    ],
    redirect: (BuildContext context, GoRouterState state) {
      final bool loggedIn = loginState.loggedIn;
      final bool loggingIn = state.subloc == loginRoutePath;
      if (!loggedIn && !loggingIn) {
        return loginRoutePath;
      }
      if (loggedIn && loggingIn) {
        return homepageRoutePath;
      }
      return null;
    },
  );
}
