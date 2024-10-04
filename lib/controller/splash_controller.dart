import 'package:get/get.dart';
import 'package:pluton_mobile_app/routing/app_routes.dart';
import 'package:pluton_mobile_app/view/home_view.dart';
import 'package:pluton_mobile_app/view/login_view.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Adjust the import according to your file structure

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();

    // Check if user is logged in
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? uid = prefs.getString('uid');

    await Future.delayed(const Duration(seconds: 3), () {
      if (uid != null) {

        // User is signed in, navigate to HomeView
        print("User is logged in, navigating to HomeView ${uid}");
        Get.off(() => const HomeView());
      } else {
        // User is not signed in, navigate to LoginView
        print("No user data found, navigating to LoginView");
        Get.off(() => const LoginView());
      }
    });
  }
}
