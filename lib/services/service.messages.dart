import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class MessageService {
  final String baseUrl = 'https://mds.sprw.dev';

  Future<List<dynamic>> getAllMessages(int conversationId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
      };

      final url = Uri.parse('$baseUrl/conversations/$conversationId/messages');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load messages: ${response.statusCode}');
      }
    } else {
      throw Exception('JWT token not found in SharedPreferences');
    }
  }

  Future<void> postMessage(int conversationId, String content) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
        'Content-Type': 'application/json',
      };

      final url = Uri.parse('$baseUrl/conversations/$conversationId/messages');
      final body = jsonEncode({'content': content});

      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode != 201) {
        throw Exception('Failed to post message: ${response.statusCode}');
      }
      print("Message posted successfully");
    } else {
      throw Exception('JWT token not found in SharedPreferences');
    }
  }
}
