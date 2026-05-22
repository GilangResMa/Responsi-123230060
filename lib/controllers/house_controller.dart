import 'package:get/get.dart';
import '../models/house_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';

class HouseController extends GetxController {
  var houses = <HouseModel>[].obs;
  var selectedHouse = Rxn<HouseModel>();
  var isLoading = false.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHouses();
    loadSelectedHouse();
  }

  void fetchHouses() async {
    try {
      isLoading.value = true;
      error.value = '';
      final fetchedHouses = await ApiService.fetchHouses();
      houses.value = fetchedHouses;
    } catch (e) {
      error.value = 'Error fetching houses: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> selectHouse(HouseModel house) async {
    await StorageService.setSelectedHouse(house);
    selectedHouse.value = house;
  }

  void loadSelectedHouse() async {
    try {
      final house = await StorageService.getSelectedHouse();
      selectedHouse.value = house;
    } catch (e) {
      error.value = 'Error loading selected house: $e';
    }
  }
}
