import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pluton_mobile_app/controller/favorite_controller.dart';

class FavoriteView extends StatelessWidget {
  const FavoriteView({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoriteController controller = Get.put(FavoriteController());

    return Scaffold(
      appBar: AppBar(
        iconTheme:const  IconThemeData(
    color: Colors.white, 
  ),
        title: const Text("Favorite Posts",style: TextStyle(color: Colors.white),),
        backgroundColor: const Color(0xFF5A4FCF),
      ),
      body: Stack(
        children: [
          Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/background.png'), // Background image
              fit: BoxFit.cover,
            ),
          ),
        ),
          Obx(() {
        if (controller.favoritePosts.isEmpty) {
          return const Center(child: Text("No favorite posts available",style: TextStyle(color: Colors.white, fontSize: 18),));
        }

        return ListView.builder(
          itemCount: controller.favoritePosts.length,
          itemBuilder: (context, index) {
            final post = controller.favoritePosts[index];

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              post.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.favorite, color: Colors.red),
                            onPressed: () {
                              controller.toggleFavorite(post); // Unfavorite post
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        post.body,
                        style: const TextStyle(fontSize: 13),
                        maxLines: 6,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_up, color: Colors.blue),
                                onPressed: () {},
                              ),
                              Text('${post.likes}'),
                            ],
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.thumb_down, color: Colors.red),
                                onPressed: () {},
                              ),
                              Text('${post.dislikes}'),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
        ],
      )
    );
  }
}
