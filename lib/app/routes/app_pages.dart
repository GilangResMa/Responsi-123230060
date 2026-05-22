import 'package:get/get.dart';
import '../../views/login_view.dart';
import '../../views/home_view.dart';
import '../../views/spell_view.dart';
import '../../views/favorite_spell_view.dart';
import '../../views/house_view.dart';
import '../../views/profile_view.dart';

abstract class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String spells = '/spells';
  static const String favoriteSpells = '/favorite-spells';
  static const String houses = '/houses';
  static const String profile = '/profile';
}

abstract class AppPages {
  static final pages = [
    GetPage(name: Routes.login, page: () => const LoginView()),
    GetPage(name: Routes.home, page: () => const HomeView()),
    GetPage(name: Routes.spells, page: () => const SpellView()),
    GetPage(name: Routes.favoriteSpells, page: () => const FavoriteSpellView()),
    GetPage(name: Routes.houses, page: () => const HouseView()),
    GetPage(name: Routes.profile, page: () => const ProfileView()),
  ];
}
