import 'dart:ui';

import 'package:get/get.dart';
import '../models/spell_model.dart';
import '../services/api_service.dart';
import '../services/storage_service.dart';
import '../services/notification_services.dart';

class SpellController extends GetxController {
  var spells = <Spells>[].obs;
  var favoriteSpells = <Spells>[].obs;
  var isLoading = false.obs;
  var error = ''.obs;
  var favoriteIds = <String>{}.obs;
  var errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSpells();
    loadFavoriteSpells();
  }

  Future<void> fetchSpells() async {
    try {
      errorMessage.value = '';
      isLoading.value = true;
      final result = await ApiService.fetchSpells();
      spells.value = result;
      
      // Load favorite status for each spell
      for (var spell in result) {
        final isFav = await StorageService.isFavoriteSpell(spell.index?.toString() ?? '');
        if (isFav) {
          favoriteIds.add(spell.index?.toString() ?? '');
        }
      }
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar('Error', 'Failed to load spells: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadFavoriteSpells() async {
    try {
      isLoading.value = true;
      final result = await StorageService.getFavoriteSpells();
      favoriteSpells.value = result;
    } catch (e) {
      Get.snackbar('Error', 'Failed to load favorites: $e',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> toggleFavoriteSpell(Spells spell) async {
    try {
      final spellIndex = spell.index?.toString() ?? '';
      final isFav = favoriteIds.contains(spellIndex);
      
      if (isFav) {
        await StorageService.removeFavoriteSpell(spellIndex);
        favoriteIds.remove(spellIndex);
        favoriteSpells.removeWhere((s) => s.index == spell.index);
        Get.snackbar(
          'Removed',
          '${spell.spell} removed from favorites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 255, 102, 102),
          colorText: const Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 2),
        );
      } else {
        await StorageService.addFavoriteSpell(spell);
        favoriteIds.add(spellIndex);
        favoriteSpells.add(spell);
        Get.snackbar(
          'Added',
          '${spell.spell} added to favorites',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color.fromARGB(255, 67, 148, 0),
          colorText: const Color.fromARGB(255, 255, 255, 255),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to update favorite: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  Future<void> removeFavoriteSpell(Spells spell) async {
    try {
      final spellIndex = spell.index?.toString() ?? '';
      await StorageService.removeFavoriteSpell(spellIndex);
      favoriteIds.remove(spellIndex);
      await loadFavoriteSpells();
      
      // Show immediate notification
      await NotificationService.showNotification(
        title: 'Spell Removed',
        body: 'You deleted ${spell.spell} from your favorites',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to remove favorite: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  bool isFavorite(String spellId) {
    return favoriteIds.contains(spellId);
  }
}
