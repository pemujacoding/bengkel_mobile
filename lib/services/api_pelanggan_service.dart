import 'dart:convert';
import 'package:http/http.dart' as http;

class PelangganService {
  static const String baseUrl =
      'https://bengkel-226557433828.us-central1.run.app/data';

  static Future<bool> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/pelanggan'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userData),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<bool> updateUser(int id, Map<String, dynamic> userData) async {
    final response = await http.put(
      Uri.parse('$baseUrl/pelanggan/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userData),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteUser(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/pelanggan/$id'));
    return response.statusCode == 200;
  }
}
