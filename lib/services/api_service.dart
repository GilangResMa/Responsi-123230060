import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/spell_model.dart';
import '../models/house_model.dart';

class ApiService {
  static const String baseUrl = 'https://potterapi-fedeperin.vercel.app/en';

  static Future<List<Spells>> fetchSpells() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/spells'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => Spells.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load spells');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<HouseModel>> fetchHouses() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/houses'));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((json) => HouseModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load houses');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
