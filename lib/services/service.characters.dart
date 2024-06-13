import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CharacterService {
  final String baseUrl = 'https://mds.sprw.dev';

  getAllCharactersByUnivers(int universId) async {
    final url = Uri.parse('$baseUrl/universes/$universId/characters');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.body);
        throw Exception('Failed to get characters: ${response.statusCode}');
      }
    }
  }

  Future getCharacter(int characterId) async {
    final url = Uri.parse('$baseUrl/characters/$characterId');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.body);
        throw Exception('Failed to get character: ${response.statusCode}');
      }
    }
  }
  
  Future<void> updateCharacterById(int universeId, int characterId) async {
    final url = Uri.parse('$baseUrl/universes/$universeId/characters/$characterId');
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.put(url, headers: headers);
      if (response.statusCode == 200) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.body);
        throw Exception('Failed to update character: ${response.statusCode}');
      }
    }
  }
}
