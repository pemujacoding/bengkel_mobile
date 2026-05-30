import 'dart:convert';
import 'package:bengkel/models/transaksi_model.dart';
import 'package:http/http.dart' as http;
import '../models/pelanggan_model.dart';
import '../models/kendaraan_model.dart';
import '../models/riwayat_service_model.dart';
import '../models/sparepart_model.dart';
import '../models/sparepart_digunakan_model.dart';

class ApiService {
  static const String baseUrl =
      'https://bengkel-226557433828.us-central1.run.app/data';

  // 1. Ambil Profil Pelanggan berdasarkan ID
  static Future<Pelanggan> fetchPelangganById(int pelangganId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/pelanggan/$pelangganId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Pelanggan.fromJson(data);
    } else {
      throw Exception('Gagal mengambil data pelanggan');
    }
  }

  // 2. Ambil Semua Kendaraan Milik Pelanggan Tertentu
  static Future<List<Kendaraan>> fetchKendaraanByPelanggan(
    int pelangganId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/kendaraan/pelanggan/$pelangganId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Kendaraan.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil data kendaraan');
    }
  }

  // 3. Ambil Riwayat Service berdasarkan ID Kendaraan
  static Future<List<RiwayatService>> fetchRiwayatService(
    int kendaraanId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/riwayat-service/kendaraan/$kendaraanId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => RiwayatService.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil riwayat service');
    }
  }

  // 4. Ambil Semua List Sparepart (untuk katalog/pilihan di app)
  static Future<List<Sparepart>> fetchAllSpareparts() async {
    final response = await http.get(Uri.parse('$baseUrl/sparepart'));

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((json) => Sparepart.fromJson(json)).toList();
    } else {
      throw Exception('Gagal mengambil daftar sparepart');
    }
  }

  // 5. BONUS: Ambil Sparepart yang Digunakan berdasarkan ID Riwayat Service
  static Future<List<SparepartDigunakan>> fetchSparepartByRiwayat(
    int riwayatId,
  ) async {
    final response = await http.get(
      Uri.parse('$baseUrl/sparepart-digunakan/riwayat/$riwayatId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data
          .map((json) => SparepartDigunakan.fromJson(json))
          .where((item) => item.idRiwayat == riwayatId)
          .toList();
    } else {
      throw Exception('Gagal mengambil data sparepart digunakan');
    }
  }

  static Future<Transaksi> fetchTransaksiById(int riwayatId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/transaksi/riwayat-service/$riwayatId'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Transaksi.fromJson(data);
    } else {
      throw Exception('Gagal mengambil data transaksi');
    }
  }
}
