//Carga service
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/carga.dart';
import '../models/dashbord_summary.dart';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';

class CargaService {
  late final String _baseUrl;

  CargaService() {
    if (kIsWeb) {
      _baseUrl = 'http://localhost:8000/api'; // para web
    } else if (Platform.isAndroid) {
      _baseUrl = 'http://10.0.2.2:8000/api'; // para android
    } else if (Platform.isIOS) {
      _baseUrl = 'http://localhost:8000/api'; // para iOS
    } else {
      _baseUrl =
          'http://localhost:8000/api'; // para desktop (Windows, macOS, Linux)
    }
    print('Base URL configurada para: $_baseUrl');
  }

  Future<List<Carga>> getCargas() async {
    print('Enviando GET para $_baseUrl/cargas');
    final response = await http.get(Uri.parse('$_baseUrl/cargas'));

    if (response.statusCode == 200) {
      List<dynamic> body = json.decode(response.body);
      return body.map((dynamic item) => Carga.fromJson(item)).toList();
    } else {
      print(
          'Erro ao carregar cargas: Status ${response.statusCode}, Body: ${response.body}');
      throw Exception('Falha ao carregar cargas: ${response.statusCode}');
    }
  }

  Future<Carga> addCargas(Carga carga) async {
    print('Enviando POST para: $_baseUrl/cargas com dados: ${carga.toJson()}');
    final response = await http.post(
      Uri.parse('$_baseUrl/cargas'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(carga.toJson()),
    );

    if (response.statusCode == 201) {
      print('Carga adicionada com sucesso: ${response.body}');
      return Carga.fromJson(json.decode(response.body));
    } else {
      print(
          'Erro ao adicionar carga: Status ${response.statusCode}, Detalhes: ${response.body}');
      throw Exception(
          'Falha ao adicionar carga: ${response.statusCode}, Detalhes: ${response.body}');
    }
  }

  Future<DashbordSummary> getDashbordSummary() async {
    print('Enviando GET para: $_baseUrl/dashboard/summary');
    final response = await http.get(Uri.parse('$_baseUrl/dashboard/summary'));

    if (response.statusCode == 200) {
      return DashbordSummary.fromJson(json.decode(response.body));
    } else {   
      print('Erro ao carregar resumo: Status ${response.statusCode}, Body: ${response.body}');
      throw Exception('Falha ao carregar resumo do dashboard: ${response.statusCode}');
    }
  }
}



