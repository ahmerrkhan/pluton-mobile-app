import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pluton_mobile_app/model/posts_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  var favoritePosts = <Post>[].obs;
  final String favoriteKey = "favorite_posts"; // Key to store favorite posts

  @override
  void onInit() {
    super.onInit();
    loadFavorites(); // Load favorites when the app starts
  }

  // Toggle a post's favorite status
  void toggleFavorite(Post post) {
    if (favoritePosts.contains(post)) {
      favoritePosts.remove(post); // Unfavorite the post
    } else {
      favoritePosts.add(post); // Add the post to favorites
    }
    saveFavorites();
  }

  // Check if a post is in favorites
  bool isFavorite(Post post) {
    return favoritePosts.contains(post);
  }

  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePostIds =
        favoritePosts.map((post) => post.id.toString()).toList();
    await prefs.setStringList(favoriteKey, favoritePostIds);
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritePostIds = prefs.getStringList(favoriteKey);

    if (favoritePostIds != null) {
      List<Post> loadedFavoritePosts = [];
      for (String id in favoritePostIds) {
        final postId = int.tryParse(id);
        if (postId != null) {
          Post? post = findPostById(postId);
          if (post != null) {
            loadedFavoritePosts.add(post);
          }
        }
      }
      favoritePosts.assignAll(loadedFavoritePosts);
    }
  }

  Post? findPostById(int postId) {
    return null;
  }
}
