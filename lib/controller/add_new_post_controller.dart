import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pluton_mobile_app/services/network_service.dart';

class AddPostController extends GetxController {
  var isSubmitting = false.obs;  // State for submission progress

  // Text controllers for the form fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  final NetworkService _networkService = NetworkService();

  // Dispose the text controllers when not needed
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
      // Prepare the data for the new post
      final data = {
        'title': title,
        // 'body': body,
        'userId': 1,  // Assuming a dummy user ID for now
      };

      final response = await _networkService.postRequest('posts/add', data);

      print("Printing response : ${response?.data}");

      if (response != null) {
        Get.back();  // Go back after successful post creation
        // Get.snackbar("Success", "Post created successfully");
       Fluttertoast.showToast(msg: "Post created successfully",
        textColor: Colors.black,
        backgroundColor: const Color(0xffD3D3D3));
      } else {
        Get.snackbar("Error", "Failed to create post");
      }
    } catch (e) {
      print("Error adding post: $e");
      Get.snackbar("Error", "Something went wrong");
    } finally {
      isSubmitting(false);
    }
  }
}
