import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:rumah_sakit_app/model/rumah_sakit_model.dart';


class ApiService {
  static const String baseUrl = 'http://192.168.111.225:8000/api/hospital';

  // Sesuaikan jika API kamu pakai {"data": [...]} atau langsung [...]
  static Future<List<RumahSakit>> fetchAll() async {
    final response = await http.get(Uri.parse(baseUrl));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Cek apakah respons berisi key 'data'
      final List data = body is List ? body : body['data'];
      return data.map((e) => RumahSakit.fromJson(e)).toList();
    } else {
      throw Exception('Gagal memuat data');
    }
  }

  static Future<RumahSakit> fetchDetail(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/$id'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);

      // Cek apakah respons berisi key 'data'
      final detail = body is Map && body.containsKey('data') ? body['data'] : body;
      return RumahSakit.fromJson(detail);
    } else {
      throw Exception('Gagal memuat detail rumah sakit');
    }
  }

  static Future<void> create(RumahSakit rs) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(rs.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('Gagal menambahkan rumah sakit');
    }
  }

  static Future<void> update(int id, RumahSakit rs) async {
    final response = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(rs.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Gagal memperbarui rumah sakit');
    }
  }

  static Future<void> delete(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));
    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus rumah sakit');
    }
  }
}