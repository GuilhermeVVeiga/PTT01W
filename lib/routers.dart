import 'package:app/Pages/LoginAPI.dart';
import 'package:app/Pages/Reflesh.dart';
import 'package:app/Pages/Tutorial.dart';

import 'Pages/Homepage.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class rotas {
  static GoRouter router = GoRouter(
    routes: <RouteBase>[
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) {
          return LoginApi();
        },
      ),
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) {
          return SplashPage(page: MyHomePage());
        },
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext context, GoRouterState state) {
          return SplashPage(page: MyHomePage());
        },
      ),
    ],
  );
}