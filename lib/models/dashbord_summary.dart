// lib/models/dashbord_summary.dart

class DashbordSummary {
  final double totalCargas;
  final double totalComissoes;

  DashbordSummary({
    required this.totalCargas,
    required this.totalComissoes,
  });

  factory DashbordSummary.fromJson(Map<String, dynamic> json) {
    double parseValue(dynamic value) {
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      } else if (value is num) {
        return value.toDouble();
      }
      return 0.0;
    }

    return DashbordSummary(
      totalCargas: parseValue(json['total_cargas']),
      totalComissoes: parseValue(json['total_comissoes']),
    );
  }
}