import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:pluton_mobile_app/controller/add_new_post_controller.dart';

class AddNewPostView extends StatelessWidget {
  AddNewPostView({super.key}); // Remove 'const' to allow FormKey usage

  final _formKey = GlobalKey<FormState>(); // Form key to manage form state

  @override
  Widget build(BuildContext context) {
    final AddPostController controller = Get.put(AddPostController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "Add New Post",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF5A4FCF),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Title",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Title cannot be empty'; // Validator for title
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              const Text(
                "Body",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: controller.bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Body cannot be empty'; // Validator for body
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              Obx(() {
                return Container(
                  height: 50,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(12.0)),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF5A4FCF),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    onPressed: () {
                      // Validate the form
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, proceed with submitting
                        controller.addNewPost();
                      }
                    },
                    child: controller.isSubmitting.value
                        ? const SizedBox(
                            height: 20.0,
                            width: 20.0,
                            child: Center(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2.0,
                            )),
                          )
                        : const Text(
                            "Submit",
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                  ),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
