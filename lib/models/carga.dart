// lib/models/carga.dart
import 'package:intl/intl.dart';

class Carga {
  final int? id;
  final String descricao;
  final double valor;
  final double percentualComissao;
  final String dataCarga;
  final double? comissao;

  Carga({
    this.id,
    required this.descricao,
    required this.valor,
    required this.percentualComissao,
    required this.dataCarga,
    this.comissao,
  });

  factory Carga.fromJson(Map<String, dynamic> json) {
    return Carga(
      id: json['id'] as int?,
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      percentualComissao: (json['percentual_comissao'] as num).toDouble(),
      dataCarga: json['data_carga'] as String,
      comissao: (json['comissao'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'valor': valor,
      'percentual_comissao': percentualComissao,
      'data_carga': dataCarga,
    };
  }
}
