import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pluton_mobile_app/controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final SplashController controller = Get.put(SplashController());

    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'), 
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 30,
            width: 80,
            height: 200,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/light-1.png'), 
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            left: 140,
            width: 80,
            height: 150,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/light-2.png'), 
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
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
