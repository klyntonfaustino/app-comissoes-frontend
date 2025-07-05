class Carga {
  final String descricao;
  final double valor;
  final double percentual;
  final double comissao;

  Carga({
    required this.descricao,
    required this.valor,
    required this.percentual,
  }) : comissao = (valor * percentual) / 100;

  factory Carga.fromJson(Map<String, dynamic> json) {
    return Carga(
      descricao: json['descricao'] as String,
      valor: (json['valor'] as num).toDouble(),
      percentual: (json['percentual'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'descricao': descricao,
      'valor': valor,
      'percentual_comissao': percentual,
    };
  }
}
