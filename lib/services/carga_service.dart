import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carga.dart';

class CargaService {
  final String _baseUrl = 'http://10.0.2.2:8000/api';

  Future<List<Carga>> getCargas() async {
    final response = await http.get(Uri.parse('$_baseUrl/cargas'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Carga.fromJson(item)).toList();
    } else {
      throw Exception('Falha ao carregar as cargas: ${response.statusCode}');
    }
  }

  Future<Carga> addCarga(Carga carga) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/cargas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(carga.toJson()),
    );

    if (response.statusCode == 201) {
      return Carga.fromJson(json.decode(response.body));
    } else {
      throw Exception('Falha ao adicionar carga: ${response.statusCode}');
    }
  }
}
