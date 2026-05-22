import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/spell_controller.dart';
import '../../controllers/house_controller.dart';
import '../../controllers/profile_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<SpellController>(SpellController());
    Get.put<HouseController>(HouseController());
    Get.put<ProfileController>(ProfileController());
  }
}
