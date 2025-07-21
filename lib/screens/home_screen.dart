import 'package:flutter/material.dart';
import '../models/carga.dart';
import '../services/carga_service.dart';
import 'nova_carga_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final CargaService _cargaService = CargaService();
  late Future<List<Carga>> _cargasFuture;

  @override
  void initState() {
    super.initState();
    _cargasFuture = _cargaService.getCargas();
  }

  void _refreshCargas() {
    setState(() {
      _cargasFuture = _cargaService.getCargas();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Cargas e Comissões'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Carga>>(
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
              padding: const EdgeInsets.all(8.0),
              itemCount: cargas.length,
              itemBuilder: (context, index) {
                final carga = cargas[index];

                print(
                    'DEBUG: Carga ID: ${carga.id}, Descrição: ${carga.descricao}, Comissão (raw): ${carga.comissao}');

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
