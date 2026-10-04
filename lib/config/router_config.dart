import 'dart:convert';

import 'package:anganwadi_connect/config/routing_service.dart';
import 'package:anganwadi_connect/views/anganwadi/anganwadi_create_screen.dart';
import 'package:anganwadi_connect/views/anganwadi/anganwadi_list_screen.dart';
import 'package:anganwadi_connect/views/employee/employee_add_screen.dart';
import 'package:anganwadi_connect/views/employee/employee_list_screen.dart';
import 'package:anganwadi_connect/views/home_screen.dart';
import 'package:anganwadi_connect/views/language_screen.dart';
import 'package:anganwadi_connect/views/login_screen.dart';
import 'package:anganwadi_connect/views/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../config/route_names.dart';

class PageRouter {
  final GoRouter router = GoRouter(
    navigatorKey: RoutingService.navigatorKey,
    initialLocation: Routes.splashScreen.path,
    routes: <RouteBase>[
      GoRoute(
        path: Routes.splashScreen.path,
        name: Routes.splashScreen.name,
        builder: (context, state) => SplashScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen.path,
        name: Routes.loginScreen.name,
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: Routes.homeScreen.path,
        name: Routes.homeScreen.name,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Routes.languageScreen.path,
        name: Routes.languageScreen.name,
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: Routes.employeeListScreen.path,
        name: Routes.employeeListScreen.name,
        builder: (context, state) => const EmployeeListScreen(),
      ),

      GoRoute(
        path: Routes.employeeAddScreen.path,
        name: Routes.employeeAddScreen.name,
        builder: (context, state) => const EmployeeAddScreen(),
      ),
       GoRoute(
        path: Routes.anganwadiAddScreen.path,
        name: Routes.anganwadiAddScreen.name,
        builder: (context, state) => const AnganwadiAddScreen(),
      ),
       GoRoute(
        path: Routes.anganwadiListScreen.path,
        name: Routes.anganwadiListScreen.name,
        builder: (context, state) => const AnganwadiListScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Page not found: ${state.fullPath}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.goNamed(Routes.splashScreen.name),
              child: const Text('Go to Home'),
            ),
          ],
        ),
      ),
    ),
  );
}
