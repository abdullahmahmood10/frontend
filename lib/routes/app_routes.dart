import 'package:flutter/material.dart';
import 'package:mmm_s_application3/presentation/login_screen/login_screen.dart';
import 'package:mmm_s_application3/presentation/homepage_screen/homepage_screen.dart';
import 'package:mmm_s_application3/presentation/chat_screen/chat_screen.dart';
import 'package:mmm_s_application3/presentation/app_navigation_screen/app_navigation_screen.dart';

class AppRoutes {
  static const String loginScreen = '/login_screen';

  static const String homepageScreen = '/homepage_screen';

  static const String chatScreen = '/chat_screen';

  static const String appNavigationScreen = '/app_navigation_screen';

  static Map<String, WidgetBuilder> routes = {
    loginScreen: (context) => LoginScreen(),
    homepageScreen: (context) => HomepageScreen(),
    chatScreen: (context) => ChatScreen(),
    appNavigationScreen: (context) => AppNavigationScreen()
  };
}
