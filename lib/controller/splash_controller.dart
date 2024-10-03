import 'package:get/get.dart';
import 'package:pluton_mobile_app/routing/app_routes.dart';
import 'package:pluton_mobile_app/view/login_view.dart'; // Adjust the import according to your file structure

class SplashController extends GetxController {
  @override
  void onInit() async {
    super.onInit();
    await Future.delayed(const Duration(seconds: 3), () {
      print("Printing after 3 seconds");
      Get.to(() => const LoginView());
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
