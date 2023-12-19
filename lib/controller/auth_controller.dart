import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:grab/config/injection.dart';
import 'package:grab/data/model/customer_model.dart';
import 'package:grab/data/model/driver_model.dart';
import 'package:grab/data/repository/customer_repository.dart';
import 'package:grab/presentations/screens/home_screen.dart';
import 'package:grab/presentations/screens/login_screen.dart';
import 'package:grab/utils/constants/themes.dart';

class AuthController extends GetxController {
  static AuthController instance = Get.find();
  late Rx<User?> _user;
  bool isLoging = false;
  User? get user => _user.value;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CustomerRepository cusRepo = getIt.get<CustomerRepository>();
  CustomerModel? customer;
  DriverModel? driver;
  @override
  void onReady() {
    super.onReady();
    _user = Rx<User?>(auth.currentUser);
    _user.bindStream(auth.authStateChanges());
    ever(_user, loginRedirect);
  }

  loginRedirect(User? user) {
    Timer(Duration(seconds: isLoging ? 0 : 2), () {
      if (user == null) {
        isLoging = false;
        update();
        Get.offAll(() => const LoginScreen());
      } else {
        isLoging = true;
        update();
        //Get.offAll(() => const HomeScreen());
      }
    });
  }

  void registerUser(email, password, name, phoneNumber) async {
    try {
      isLoging = true;
      update();
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      CustomerModel newCustomer = CustomerModel(
          name: name,
          id: _user.value!.uid,
          phoneNumber: phoneNumber,
          email: email,
          createdAt: Timestamp.now());

      await cusRepo.createCustomer(newCustomer);
      getSuccessSnackBar("Successfully logged in as ${_user.value!.email}");
      Navigator.pushReplacement(
        Get.overlayContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } on FirebaseAuthException catch (e) {
      //define error
      getErrorSnackBar("Account Creating Failed", e);
    } catch (e) {
      // Handle other unexpected exceptions during registration
      print(e);
      getErrorSnackBar("Unexpected Error", e.toString());
    }
  }

  void login(email, password, ctx) async {
    try {
      isLoging = true;
      update();
      await auth.signInWithEmailAndPassword(email: email, password: password);
       customer = await cusRepo.readCustomer(_user.value!.uid);
      // final GlobalState globalState = ctx.read<GlobalState>();
      // globalState.setCustomer(customer!);
      // print(globalState.customer!.name);
      getSuccessSnackBar("Successfully logged in as ${_user.value!.email}");
      Navigator.pushReplacement(
        Get.overlayContext!,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } on FirebaseAuthException catch (e) {
      //define error
      getErrorSnackBar("Login Failed", e);
    } catch (e) {
      // Handle other unexpected exceptions during registration
      print(e);
      getErrorSnackBar("Unexpected Error", e.toString());
    }
  }

  void googleLogin() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    isLoging = true;
    update();
    try {
      googleSignIn.disconnect();
    } catch (e) {}
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication? googleAuth =
            await googleSignInAccount.authentication;
        final crendentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken,
          idToken: googleAuth?.idToken,
        );
        await auth.signInWithCredential(crendentials);
        getSuccessSnackBar("Successfully logged in as ${_user.value!.email}");
        Navigator.pushReplacement(
          Get.overlayContext!,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      getErrorSnackBar("Google Login Failed", e);
    } on PlatformException catch (e) {
      print(e);
      getErrorSnackBar("Google Login Failed", e);
    }
  }

  void forgorPassword(email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
      getSuccessSnackBar("Reset mail sent successfully. Check mail!");
    } on FirebaseAuthException catch (e) {
      getErrorSnackBar("Error", e);
    }
  }

  getErrorSnackBar(String message, _) {
    Get.snackbar(
      "Error",
      "$message\n${_.message}",
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MyTheme.redTextColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
  }

  getErrorSnackBarNew(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MyTheme.redTextColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
  }

  getSuccessSnackBar(String message) {
    Get.snackbar(
      "Success",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: MyTheme.greenTextColor,
      colorText: Colors.white,
      borderRadius: 10,
      margin: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
    );
  }

  void signOut() async {
    await auth.signOut();
  }
}