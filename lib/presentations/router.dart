
import 'package:flutter/material.dart';
import 'package:grab/middlewares/authentication.dart';
import 'package:grab/presentations/screens/home_screen.dart';
import 'package:grab/presentations/screens/login_screen.dart';
import 'package:grab/presentations/screens/splash_screen.dart';
import 'package:get/get.dart';

class AppRoutes {
  static final pages = [
    GetPage(
      name: AppLinks.SPLASH,
      page: () => SplashScreen(),
      
      
    ),
    GetPage(
      name: AppLinks.LOGIN,
      page: () => LoginScreen(),
      
      
       
    ),
    GetPage(
      name: AppLinks.HOME,
      page: () => HomeScreen(),
      
      
     
    ),
    GetPage(
      name: '/check-auth',
      page: () => Container(), // A placeholder, won't actually be shown
      middlewares: [AuthGuard()],
    ),
    ];
}

class AppLinks {
  static const String SPLASH = "/splash";
  static const String LOGIN = "/login";
  static const String HOME = "/home";
}
