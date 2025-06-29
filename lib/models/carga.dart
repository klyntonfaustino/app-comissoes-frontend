import 'dart:convert';

class Carga {
  final String descricao;
  final double valor;
  final double percentual;
  double comissao;

  Carga({
    required this.descricao,
    required this.valor,
    required this.percentual,
    this.comissao = 0.0,
  }) {
    this.comissao = (valor * percentual) / 100;
  }

  factory Carga.fromJson(Map<String, dynamic> json) {
    return Carga(
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      percentual: (json['percentual'] as num).toDouble(),
      comissao: (json['comissao'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'valor': valor,
      'percentual': percentual,
      'comissao': comissao,
    };
  }
}
