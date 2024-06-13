import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UniverseService {
  final String baseUrl = 'https://mds.sprw.dev';

  Uri fetchUniverseImg(String? imgUniverse) {
    if (imgUniverse != null) {
      Uri url = Uri.parse('https://mds.sprw.dev/image_data/$imgUniverse');
      return url;
    }
    return Uri.parse('https://picsum.photos/500/');
  }

  Future<void> createUniverse(String name) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      };

      final url = Uri.parse('$baseUrl/universes');
      final body = jsonEncode({'name': name});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 201) {
        // Univers créé avec succès
      } else {
        throw Exception('Failed to create universe: ${response.statusCode}');
      }
    } else {
      throw Exception('Missing JWT token: Authorization required');
    }
  }

  Future<void> updateUniverse(int universeId, String newName) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      };

      final url = Uri.parse('$baseUrl/universes/$universeId');
      final body = jsonEncode({'name': newName});

      final response = await http.put(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        // Univers mis à jour avec succès
      } else {
        throw Exception('Failed to update universe: ${response.statusCode}');
      }
    } else {
      throw Exception('Missing JWT token: Authorization required');
    }
  }

  Future<List<dynamic>> getUniverses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
      };

      final url = Uri.parse('$baseUrl/universes');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load universes: ${response.statusCode}');
      }
    } else {
      throw Exception('Missing JWT token: Authorization required');
    }
  }
}
