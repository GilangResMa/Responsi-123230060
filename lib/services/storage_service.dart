import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';
import '../models/spell_model.dart';
import '../models/house_model.dart';

class StorageService {
  static const String _userKey = 'user_data';
  static const String _favoritesKey = 'favorite_spells';
  static const String _houseKey = 'selected_house';

  // User Management
  static Future<void> saveUser(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, jsonEncode({
      'username': username,
      'password': password,
    }));
  }

  static Future<Map<String, dynamic>?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userData = prefs.getString(_userKey);
    if (userData == null) return null;
    return jsonDecode(userData);
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  static Future<void> initHive() async {
    await Hive.initFlutter();
    await Hive.openBox<String>(_favoritesKey);
  }

  // Favorite Spells Management
  static Future<void> addFavoriteSpell(Spells spell) async {
    try {
      final spellIndex = spell.index?.toString();
      if (spellIndex == null || spellIndex.isEmpty) {
        throw Exception('Spell index cannot be null or empty');
      }
      
      // Ensure box is open
      if (!Hive.isBoxOpen(_favoritesKey)) {
        await Hive.openBox<String>(_favoritesKey);
      }
      
      final box = Hive.box<String>(_favoritesKey);
      await box.put(spellIndex, jsonEncode(spell.toJson()));
    } catch (e) {
      throw Exception('Failed to add favorite spell: $e');
    }
  }

  static Future<void> removeFavoriteSpell(String spellId) async {
    try {
      // Ensure box is open
      if (!Hive.isBoxOpen(_favoritesKey)) {
        await Hive.openBox<String>(_favoritesKey);
      }
      
      final box = Hive.box<String>(_favoritesKey);
      await box.delete(spellId);
    } catch (e) {
      throw Exception('Failed to remove favorite spell: $e');
    }
  }

  static Future<List<Spells>> getFavoriteSpells() async {
    try {
      // Ensure box is open
      if (!Hive.isBoxOpen(_favoritesKey)) {
        await Hive.openBox<String>(_favoritesKey);
      }
      
      final box = Hive.box<String>(_favoritesKey);
      List<Spells> favorites = [];
      for (var value in box.values) {
        favorites.add(Spells.fromJson(jsonDecode(value)));
      }
      return favorites;
    } catch (e) {
      throw Exception('Failed to get favorite spells: $e');
    }
  }

  static Future<bool> isFavoriteSpell(String spellId) async {
    try {
      // Ensure box is open
      if (!Hive.isBoxOpen(_favoritesKey)) {
        await Hive.openBox<String>(_favoritesKey);
      }
      
      final box = Hive.box<String>(_favoritesKey);
      return box.containsKey(spellId);
    } catch (e) {
      throw Exception('Failed to check favorite spell: $e');
    }
  }

  // House Selection
  static Future<void> setSelectedHouse(HouseModel house) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_houseKey, jsonEncode(house.toJson()));
  }

  static Future<HouseModel?> getSelectedHouse() async {
    final prefs = await SharedPreferences.getInstance();
    final houseJson = prefs.getString(_houseKey);
    if (houseJson == null) return null;
    return HouseModel.fromJson(jsonDecode(houseJson));
  }

  static Future<void> clearSelectedHouse() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_houseKey);
  }
}
