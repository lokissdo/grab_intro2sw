import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/route_middleware.dart';
import 'package:grab/presentations/router.dart';

class AuthGuard extends GetMiddleware {

  @override
  int? get priority => 1;

  @override
  RouteSettings? redirect(String? route) {
    // Check if the user is already logged in
    FirebaseAuth auth = FirebaseAuth.instance;
    bool isLoggedIn = auth.currentUser != null;
    
    if (isLoggedIn) {
      // User is already logged in, redirect to the home screen
      return RouteSettings(name: AppLinks.HOME);
    } else {
      // User is not logged in, redirect to the login screen
      return RouteSettings(name: AppLinks.LOGIN);
    }
  }
}

