import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:pluton_mobile_app/view/add_new_post_view.dart';
import 'package:pluton_mobile_app/view/favorite_view.dart';
import 'package:pluton_mobile_app/view/home_view.dart';
import 'package:pluton_mobile_app/view/login_view.dart';
import 'package:pluton_mobile_app/view/splash_view.dart';

class AppRoutes {
  static const initialRoute = '/';
  static const login = '/login';
  static const home = '/home';
  static const favorite = '/favorite';
  static const addNewPost = '/addpost';

  static final getRoutes = [
    GetPage(name: initialRoute, page: () => const SplashView()),
    GetPage(name: login, page: () => const LoginView()),
    GetPage(name: home, page: () => const HomeView()),
    GetPage(name: favorite, page: () => const FavoriteView()),
    GetPage(name: addNewPost, page: () =>  AddNewPostView()),
  ];
}
