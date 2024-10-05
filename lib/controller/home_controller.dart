import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:pluton_mobile_app/controller/favorite_controller.dart';
import 'package:pluton_mobile_app/model/posts_model.dart';
import 'package:pluton_mobile_app/services/network_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeController extends GetxController {
  RxString? displayName = "".obs;
  RxString? email = "".obs;
  RxString? photoUrl = "".obs;
  var posts = <Post>[].obs;
  var isLoading = false.obs; 
  var currentPage = 1.obs;
  var hasMoreData = true.obs;     

  final NetworkService _networkService = NetworkService();
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  void onInit() {
    super.onInit();
    getUserData();
    fetchPosts(); 
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayName?.value = prefs.getString('displayName') ?? "";
    email?.value = prefs.getString('email') ?? "";
    photoUrl?.value = prefs.getString('photoUrl') ?? "";
    update();
  }

 // Fetch posts with pagination
  Future<void> fetchPosts({int page = 1}) async {
    if (!hasMoreData.value) return;  // Stop fetching if no more data

    try {
      isLoading(true);
      final response = await _networkService.getRequest('posts', queryParams: {'limit': 10, 'skip': (page - 1) * 10});
      
      if (response != null && response.statusCode == 200) {
        List<dynamic> postList = response.data['posts'];

        if (postList.isEmpty) {
          hasMoreData(false);  
        } else {
          posts.addAll(postList.map((e) => Post.fromJson(e)).toList()); 
          currentPage.value = page; 
        }
      }
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      final response = await _networkService.deleteRequest('posts/$postId'); // Adjust the endpoint as necessary

      if (response != null && response.statusCode == 200) {
        // Remove the post from the local list
        posts.removeWhere((post) => post.id == postId); // Assuming each Post has a unique 'id' field
        update(); // Notify listeners to update the UI
      }
    } catch (e) {
      print("Error deleting post: $e");
    }
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
