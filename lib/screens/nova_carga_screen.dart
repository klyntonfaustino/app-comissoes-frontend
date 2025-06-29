import 'package:flutter/material.dart';
import '../models/carga.dart'; // ajusta o caminho se necessário
import '../services/carga_service.dart';

class NovaCargaScreen extends StatefulWidget {
  const NovaCargaScreen({super.key});

  @override
  State<NovaCargaScreen> createState() => _NovaCargaScreenState();
}

class _NovaCargaScreenState extends State<NovaCargaScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto do formulário
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final TextEditingController _percentualController = TextEditingController();

  // Instância do serviço de cargas
  final CargaService _cargaService = CargaService();

  Future<void> _salvarCarga() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String descricao = _descricaoController.text;
        final double valor = double.parse(_valorController.text);
        final double percentual = double.parse(_percentualController.text);

        final novaCarga = Carga(
          descricao: descricao,
          valor: valor,
          percentual: percentual,
        );

        await _cargaService.addCarga(novaCarga);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Carga adicionada com sucesso!')),
        );

        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        print('Erro ao salvar carga: $e');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Erro ao adicionar carga: $e')));
      }
    }
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _percentualController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Carga'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _descricaoController,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _valorController,
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o valor';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _percentualController,
                decoration: const InputDecoration(
                  labelText: 'Percentual',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o percentual';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _salvarCarga,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Salvar Carga',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
