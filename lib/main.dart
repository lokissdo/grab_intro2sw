import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:grab/presentations/screens/map_test.dart';
import 'package:grab/utils/constants/themes.dart';
import 'package:grab/utils/helpers/auth_controller.dart';
import 'firebase_options.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  // Get.put(AuthController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: MyTheme.myLightTheme,
      debugShowCheckedModeBanner: false,
      home: const MyMap(),
    );
  }
}
