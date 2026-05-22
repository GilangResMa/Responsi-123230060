import 'package:get/get.dart';
import '../services/storage_service.dart';

class AuthController extends GetxController {
  var isLoggedIn = false.obs;
  var username = ''.obs;
  var password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    final user = await StorageService.getUser();
    if (user != null) {
      isLoggedIn.value = true;
      username.value = user['username'];
      password.value = user['password'];
    }
  }

  Future<bool> login(String user, String pass) async {
    if (user.length < 5) {
      Get.snackbar('Error', 'Username harus minimal 5 karakter');
      return false;
    }

    await StorageService.saveUser(user, pass);
    username.value = user;
    password.value = pass;
    isLoggedIn.value = true;
    return true;
  }

  Future<void> logout() async {
    await StorageService.clearUser();
    await StorageService.clearSelectedHouse();
    isLoggedIn.value = false;
    username.value = '';
    password.value = '';
  }

  bool validatePassword(String input) {
    return input == password.value;
  }
}
