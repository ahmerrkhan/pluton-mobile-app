import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pluton_mobile_app/services/network_service.dart';

class AddPostController extends GetxController {
  var isSubmitting = false.obs;

  // Text controllers for the form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final NetworkService _networkService = NetworkService();

  @override
  void onClose() {
    titleController.dispose();
    bodyController.dispose();
    super.onClose();
  }

  // Method to add a new post
  Future<void> addNewPost() async {
    final String title = titleController.text;
    final String body = bodyController.text;

    if (title.isEmpty || body.isEmpty) {
      Get.snackbar("Error", "Title and body cannot be empty");
      return;
    }

    try {
      isSubmitting(true);
      final data = {
        'title': title,
        'userId': 1,
      };
      final response = await _networkService.postRequest('posts/add', data);
      print("Printing response : ${response?.data}");

      if (response != null) {
        Get.back();
        Fluttertoast.showToast(
            msg: "Post created successfully",
            textColor: Colors.black,
            backgroundColor: const Color(0xffD3D3D3));
      } else {
        // Internet check
        final Connectivity _connectivity = Connectivity();
        var connectivityResult = await _connectivity.checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          // Offline: Show toast
          Fluttertoast.showToast(
              msg: "No internet connection", backgroundColor: Colors.red);
        }
      }
    } catch (e) {
      print("Error adding post: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSubmitting(false);
    }
  }
}
