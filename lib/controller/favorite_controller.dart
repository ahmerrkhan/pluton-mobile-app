import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pluton_mobile_app/model/posts_model.dart';

import 'package:shared_preferences/shared_preferences.dart';

class FavoriteController extends GetxController {
  var favoritePosts = <Post>[].obs; // List of favorited posts
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
    saveFavorites(); // Save the updated favorites list to SharedPreferences
  }

  // Check if a post is in favorites
  bool isFavorite(Post post) {
    return favoritePosts.contains(post);
  }

  // Save the list of favorite post IDs to SharedPreferences
  Future<void> saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favoritePostIds = favoritePosts.map((post) => post.id.toString()).toList();
    await prefs.setStringList(favoriteKey, favoritePostIds);
  }

  // Load the list of favorite post IDs from SharedPreferences
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? favoritePostIds = prefs.getStringList(favoriteKey);

    if (favoritePostIds != null) {
      // Simulate fetching posts by their ID (in a real app, you'd fetch from an API or database)
      List<Post> loadedFavoritePosts = [];
      for (String id in favoritePostIds) {
        final postId = int.tryParse(id);
        if (postId != null) {
          // In a real app, you'd fetch the post by ID from a local database or API
          Post? post = findPostById(postId); // Implement this to get the post by ID
          if (post != null) {
            loadedFavoritePosts.add(post);
          }
        }
      }
      favoritePosts.assignAll(loadedFavoritePosts);
    }
  }

  // Dummy method to find a post by ID (replace with actual logic to fetch posts)
  Post? findPostById(int postId) {
    // In a real app, implement logic to fetch a post by its ID
    // For now, returning null to simulate missing implementation
    return null;
  }
}
