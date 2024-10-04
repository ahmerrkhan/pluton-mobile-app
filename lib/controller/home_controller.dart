import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxString? displayName = "".obs;
  RxString? email = "".obs;
  RxString? photoUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    getUserData();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayName?.value = prefs.getString('displayName') ?? "";
    email?.value = prefs.getString('email') ?? "";
    photoUrl?.value = prefs.getString('photoUrl') ?? "";
    update();
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
