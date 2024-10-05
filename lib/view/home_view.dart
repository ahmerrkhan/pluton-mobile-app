import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pluton_mobile_app/controller/favorite_controller.dart';
import 'package:pluton_mobile_app/controller/home_controller.dart';
import 'package:pluton_mobile_app/controller/login_controller.dart';
import 'package:pluton_mobile_app/view/add_new_post_view.dart';
import 'package:pluton_mobile_app/view/favorite_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final HomeController controller = Get.put(HomeController());
  final LoginController loginController = Get.put(LoginController());
  final FavoriteController favoriteController =
      Get.put(FavoriteController()); // Favorite controller
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent &&
          !controller.isLoading.value) {
        controller.fetchPosts(page: controller.currentPage.value + 1);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Obx(() {
              return UserAccountsDrawerHeader(
                accountName: Text(controller.displayName?.value ?? ""),
                accountEmail: Text(controller.email?.value ?? ""),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(
                    controller.photoUrl?.value ?? "",
                  ),
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF5A4FCF),
                ),
              );
            }),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms and Conditions'),
              onTap: () {
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip),
              title: const Text('Privacy Policy'),
              onTap: () {
                Get.back();
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        centerTitle: true,
        title: const Text("Home Screen",
            style: TextStyle(color: Colors.white, fontSize: 17)),
        backgroundColor: const Color(0xFF5A4FCF), // Semi-transparent black
        actions: [
          IconButton(
            onPressed: () => Get.to(() => const FavoriteView()),
            icon: const Icon(Icons.favorite, color: Colors.white),
          ),
          IconButton(
            onPressed: () {
              loginController.signOutFromGoogle();
            },
            icon: const Icon(Icons.logout, color: Colors.white),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF5A4FCF),
        onPressed: () => Get.to(() => AddNewPostView()),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Obx(() {
            if (controller.isLoading.value && controller.posts.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView.builder(
              controller: _scrollController,
              itemCount: controller.posts.length +
                  (controller.isLoading.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.posts.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final post = controller.posts[index];

                // Wrap the favorite icon in Obx to listen for changes in the favorite list
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
              // Update here: wrap IconButton in Obx
              Obx(() {
                final isFavorite = favoriteController.isFavorite(post);
                return IconButton(
                  icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border),
                  color: isFavorite ? Colors.red : Colors.grey,
                  onPressed: () {
                    favoriteController.toggleFavorite(post); // Toggle favorite state
                  },
                );
              }),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Confirm deletion
                  Get.defaultDialog(
                    title: "Delete Post",
                    middleText: "Are you sure you want to delete this post?",
                    confirm: TextButton(
                      onPressed: () {
                        controller.deletePost(post.id); // Call the delete method
                        Get.back(); // Close the dialog
                      },
                      child: const Text("Yes"),
                    ),
                    cancel: TextButton(
                      onPressed: () => Get.back(),
                      child: const Text("No"),
                    ),
                  );
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
      ),
    );
  }
}
