import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pluton_mobile_app/view/home_view.dart';
import 'package:pluton_mobile_app/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<dynamic> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Check if user is null (indicates that the sign-in was canceled)
      if (googleUser == null) {
        print("User canceled the Google sign-in");
        return; // or you can show a message to the user
      }

      final GoogleSignInAuthentication? googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Sign in with the credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Get user info
      User? user = userCredential.user;

      if (user != null) {
        // Store user info in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('uid', user.uid);
        await prefs.setString('displayName', user.displayName ?? '');
        await prefs.setString('email', user.email ?? '');
        await prefs.setString('photoUrl', user.photoURL ?? '');

        print("User signed in and data stored locally ${user.uid}");

        // Navigate to the HomeView
        Fluttertoast.showToast(msg: "User logged in successfully",
        textColor: Colors.black,
        backgroundColor: const Color(0xffD3D3D3));
        Get.off(() => const HomeView());
      }
    } on PlatformException catch (e) {
      print("Printing Exception : ${e.message}");
    } catch (e) {
      print("Unhandled Exception: $e");
    }
  }

  Future<bool> signOutFromGoogle() async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();

      // Clear user data from SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('uid');
      await prefs.remove('displayName');
      await prefs.remove('email');
      await prefs.remove('photoUrl');

      Get.off(() => const LoginView());
      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}
