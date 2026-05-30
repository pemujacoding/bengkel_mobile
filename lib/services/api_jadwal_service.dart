import 'dart:convert';
import 'package:bengkel/models/jadwal_service_model.dart';
import 'package:http/http.dart' as http;

class APIJadwalService {
  static const String baseUrl =
      'https://bengkel-226557433828.us-central1.run.app/data';

  static Future<List<JadwalService>> fetchJadwalServiceByKendaraan(
    int kendaraanId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/jadwal-service/kendaraan/$kendaraanId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => JadwalService.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil jadwal service');
    }
  }

  static Future<bool> createJadwal(Map<String, dynamic> jadwalData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/jadwal-service/'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(jadwalData),
    );
    return response.statusCode == 201 || response.statusCode == 200;
  }

  static Future<bool> updateJadwal(
    int id,
    Map<String, dynamic> jadwalData,
  ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/jadwal-service/$id'),
      headers: {"Content-Type": "application/json"},
      body: json.encode(jadwalData),
    );
    return response.statusCode == 200;
  }

  static Future<bool> deleteJadwal(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/jadwal-service/$id'),
    );
    return response.statusCode == 200;
  }
}
