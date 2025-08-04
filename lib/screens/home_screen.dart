// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import '../models/carga.dart';
import '../services/carga_service.dart';
import '../models/dashbord_summary.dart';
import 'nova_carga_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CargaService _cargaService = CargaService();
  
  // Separamos os futuros para os totais e para a lista
  late Future<DashbordSummary> _summaryFuture;
  late Future<List<Carga>> _cargasFuture;

  @override
  void initState() {
    super.initState();
    // Chamamos os dois novos métodos do serviço
    _summaryFuture = _cargaService.getDashbordSummary();
    _cargasFuture = _cargaService.getCargas();
  }

  void _refreshCargas() {
    setState(() {
      // Atualizamos os dois futuros no refresh
      _summaryFuture = _cargaService.getDashbordSummary();
      _cargasFuture = _cargaService.getCargas();
    });
  }

  Widget _buildTotalCard(String title, double value) {
    return Expanded(
      child: Card(
        color: Colors.grey[200],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'R\$ ${value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.green,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Comissões'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
           
            FutureBuilder<DashbordSummary>(
              future: _summaryFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Erro: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final summary = snapshot.data!;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTotalCard('Total de Cargas', summary.totalCargas.toDouble()),
                      _buildTotalCard('Total de Comissões', summary.totalComissoes),
                    ],
                  );
                }
                return const SizedBox.shrink();
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Navegar para Histórico (em desenvolvimento)')),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('Histórico de Cargas'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),                    
              ),
            ),
            const SizedBox(height: 20),
            const Text('Minhas Cargas', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            
            Expanded(
              child: FutureBuilder<List<Carga>>(
                future: _cargasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erro: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    List<Carga>? cargas = snapshot.data;
                    if (cargas == null || cargas.isEmpty) {
                      return const Center(
                        child: Text('Nenhuma carga encontrada. Adicione uma nova!'),
                      );
                    }
                    return ListView.builder(
                      itemCount: cargas.length,
                      itemBuilder: (context, index) {
                        final carga = cargas[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          elevation: 4.0,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  carga.descricao,
                                  style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8.0),
                                Text('Valor: R\$ ${carga.valor.toStringAsFixed(2)}'),
                                Text(
                                  'Percentual: ${carga.percentualComissao.toStringAsFixed(2)}%',
                                ),
                                Text(
                                  'Comissão: R\$ ${carga.comissao?.toStringAsFixed(2) ?? 'N/A'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return const Center(child: Text('Estado desconhecido.'));
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NovaCargaScreen()),
          );

          if (result == true) {
            _refreshCargas();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}