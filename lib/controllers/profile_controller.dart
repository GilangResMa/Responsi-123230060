import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/house_controller.dart';

class ProfileController extends GetxController {
  late AuthController authController;
  late HouseController houseController;

  @override
  void onInit() {
    super.onInit();
    authController = Get.find<AuthController>();
    houseController = Get.find<HouseController>();
  }
}
