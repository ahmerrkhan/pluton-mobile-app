import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pluton_mobile_app/controller/home_controller.dart';
import 'package:pluton_mobile_app/controller/login_controller.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final LoginController loginController = Get.put(LoginController());

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          return Text(
            controller.displayName?.value ?? "",
            style: const TextStyle(color: Colors.white),
          );
        }),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
              onPressed: () async {
                await loginController.signOutFromGoogle();
              },
              icon: const Icon(
                Icons.logout,
                color: Colors.white,
              ))
        ],
      ),
      body: const Center(
        child: Text("Home View"),
      ),
    );
  }
}
