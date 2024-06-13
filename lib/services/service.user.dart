import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserService {
  final String baseUrl = 'https://mds.sprw.dev';

  createUser(String username, String email, String password, String firstname,
      String lastname) async {
    final url = Uri.parse('$baseUrl/users');
    final response = await http.post(
      url,
      body: jsonEncode({
        'username': username,
        'email': email,
        'password': password,
        'firstname': firstname,
        'lastname': lastname
      }),
    );
    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      // debugPrint(response.body);
      print(response.body);
      throw Exception('Failed to create user: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> getAllUsers() async {
    final url = Uri.parse('$baseUrl/users');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        print('Response body: ${response.body}');
        return List<Map<String, dynamic>>.from(jsonDecode(response.body));
      } else {
        print('Failed to get users: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to get users: ${response.statusCode}');
      }
    } else {
      throw Exception('JWT token not found in SharedPreferences');
    }
  }

  Future<void> loginUser(String username, String password) async {
    final Map<String, String> data = {
      'username': username,
      'password': password,
    };

    final String jsonBody = jsonEncode(data);

    print('Sending data to API: $jsonBody');

    final response = await http.post(
      Uri.parse('$baseUrl/auth'),
      headers: {'Content-Type': 'application/json'},
      body: jsonBody,
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 201) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['token'] != null) {
        await saveToken(jsonResponse['token']);
        final tokenParts = jsonResponse['token'].split('.');
        final payload =
            json.decode(utf8.decode(base64Url.decode(tokenParts[1].padRight(
          tokenParts[1].length + (4 - tokenParts[1].length % 4) % 4,
          '=',
        ))));
        final data = jsonDecode(payload['data']);
        print('Data User: $data');
        await saveId(data['id']);
        await saveUsername(data['username']);
      }
      return jsonResponse;
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> saveToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt_token', token);
  }

  Future<void> saveId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('userId', id);
  }
  Future<void> saveUsername(String username) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<Map<String, dynamic>> updateUser(String id, String username,
      String email, String firstname, String lastname) async {
    final url = Uri.parse('$baseUrl/users/$id');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? jwtToken = prefs.getString('jwt_token');

    if (jwtToken != null) {
      final headers = <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $jwtToken',
      };

      final response = await http.put(
        url,
        headers: headers,
        body: jsonEncode({
          'username': username,
          'email': email,
          'firstname': firstname,
          'lastname': lastname,
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print(
            'Failed to update user: ${response.statusCode} - ${response.body}');
        throw Exception('Failed to update user: ${response.statusCode}');
      }
    } else {
      throw Exception('JWT token not found in SharedPreferences');
    }
  }
}
