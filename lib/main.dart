import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/controller/auth_controller.dart';
import 'package:grab/presentations/router.dart';
import 'package:grab/presentations/screens/map_screen.dart';
import 'package:grab/presentations/screens/splash_screen.dart';
import 'package:grab/utils/constants/themes.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  configureDependencies();
  Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyTheme.myLightTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: AppLinks.SPLASH,
      // getPages: AppRoutes.pages,
    );
  }
}
