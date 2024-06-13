import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ConversationService {
  final String baseUrl = 'https://mds.sprw.dev';

  getAllConversations() async {
    final url = Uri.parse('$baseUrl/conversations');
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
        throw Exception('Failed to get conversations: ${response.statusCode}');
      }
    }
  }

  startConversation(int characterId, int userId) async {
    final url = Uri.parse('$baseUrl/conversations');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      };

      final body = jsonEncode({
        'character_id': characterId,
        'user_id': userId,
      });

      final response = await http.post(url, headers: headers, body: body);
      if (response.statusCode == 201) {
        print(response.body);
        return jsonDecode(response.body);
      } else {
        print(response.body);
        throw Exception('Ca fonctionne pas: ${response.statusCode}');
      }
    }
  }
}
