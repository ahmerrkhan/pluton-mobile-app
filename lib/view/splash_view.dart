import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pluton_mobile_app/controller/splash_controller.dart';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart'; // For FadeInUp animation

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background image from the LoginView
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Positioned light-1 image
          Positioned(
            left: 30,
            width: 80,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/light-1.png'), // Light 1
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Positioned light-2 image
          Positioned(
            left: 140,
            width: 80,
            height: 150,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/light-2.png'), // Light 2
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          // Positioned CircularProgressIndicator at the center
         const  Center(
            child:  CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3.0,
            ),
          ),
        ],
      ),
    );
  }
}
