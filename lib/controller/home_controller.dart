import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pluton_mobile_app/controller/favorite_controller.dart';
import 'package:pluton_mobile_app/model/posts_model.dart';
import 'package:pluton_mobile_app/services/network_service.dart';
import 'package:pluton_mobile_app/services/offline_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

class HomeController extends GetxController {
  RxString? displayName = "".obs;
  RxString? email = "".obs;
  RxString? photoUrl = "".obs;
  var posts = <Post>[].obs;
  var isLoading = false.obs;
  var currentPage = 1.obs;
  var hasMoreData = true.obs;

  final NetworkService _networkService = NetworkService();
  final OfflineService _offlineService = OfflineService();
  final Connectivity _connectivity = Connectivity();
  final FavoriteController favoriteController = Get.put(FavoriteController());

  @override
  void onInit() {
    super.onInit();
    getUserData();
    _fetchPosts();
  }

  Future<void> getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayName?.value = prefs.getString('displayName') ?? "";
    email?.value = prefs.getString('email') ?? "";
    photoUrl?.value = prefs.getString('photoUrl') ?? "";
    update();
  }

  Future<void> _fetchPosts({int page = 1}) async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      // Offline Mode: Fetch posts from local storage
      fetchLocalPosts();
      return;
    }
    // Online Mode: Fetch posts from API and update local DB
    await fetchPosts(page: page);
  }

  // Fetch posts from API
  Future<void> fetchPosts({int page = 1}) async {
    if (!hasMoreData.value) return;

    try {
      isLoading(true);
      //Pagination implemented here
      final response = await _networkService.getRequest('posts',
          queryParams: {'limit': 10, 'skip': (page - 1) * 10});

      if (response != null && response.statusCode == 200) {
        List<dynamic> postList = response.data['posts'];
        if (postList.isEmpty) {
          hasMoreData(false);
        } else {
          List<Post> fetchedPosts =
              postList.map((e) => Post.fromJson(e)).toList();
          posts.addAll(fetchedPosts);
          currentPage.value = page;
          // Save fetched posts to local storage
          _offlineService.insertPosts(fetchedPosts);
        }
      }
    } catch (e) {
      print("Error fetching posts: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<void> fetchLocalPosts() async {
    isLoading(true);
    posts.value = await _offlineService.fetchLocalPosts();
    isLoading(false);
  }

  // Delete post both from local DB and API
  Future<void> deletePost(int postId) async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetToast();
      return;
    }

    try {
      final response = await _networkService.deleteRequest('posts/$postId');

      if (response != null && response.statusCode == 200) {
        posts.removeWhere((post) => post.id == postId);
        _offlineService.deletePost(postId);
        update();
      }
    } catch (e) {
      print("Error deleting post: $e");
    }
  }

  Future<void> deleteAllPosts() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showNoInternetToast();
      return;
    }

    try {
      // Delete all posts from the api
      posts.clear();
      await _offlineService.deleteAllPosts();
      update();
    } catch (e) {
      print("Error deleting all posts: $e");
    }
  }

  void _showNoInternetToast() {
    Fluttertoast.showToast(msg: "No Internet connection");
  }
}
