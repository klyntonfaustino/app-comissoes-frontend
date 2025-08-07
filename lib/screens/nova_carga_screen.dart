// lib/screens/nova_carga_screen.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/carga.dart';
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

  // Variáveis e controlador para a data
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();

  // Instância do serviço de cargas
  final CargaService _cargaService = CargaService();

  @override
  void initState() {
    super.initState();
    _descricaoController.addListener(() {
      setState(() {});
    });
    _valorController.addListener(() {
      setState(() {});
    });
    _percentualController.addListener(() {
      setState(() {});
    });

    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _descricaoController.dispose();
    _valorController.dispose();
    _percentualController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      });
    }
  }

  Future<void> _salvarCarga() async {
    if (_formKey.currentState!.validate()) {
      try {
        final String descricao = _descricaoController.text;
        final double valor = double.parse(_valorController.text);
        final double percentual = double.parse(_percentualController.text);

        if (_selectedDate == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Por favor, selecione a data da carga.')),
          );
          return;
        }
        final String dataCargaStr =
            DateFormat('yyyy-MM-dd').format(_selectedDate!);

        final novaCarga = Carga(
          descricao: descricao,
          valor: valor,
          percentualComissao: percentual,
          dataCarga: dataCargaStr,
          id: null,
          comissao: null,
        );

        await _cargaService.addCargas(novaCarga);

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
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12.0),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: TextFormField(
                  controller: _descricaoController,
                  decoration: const InputDecoration(
                    hintText: 'Número da Carga',
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira o número da carga';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 0,
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    controller: _valorController,
                    decoration: const InputDecoration(
                      hintText: 'Valor da Carga',
                      border: InputBorder.none,
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
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 0,
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    controller: _percentualController,
                    decoration: const InputDecoration(
                      hintText: 'Percentual de Comissão',
                      border: InputBorder.none,
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
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                elevation: 0,
                color: Colors.grey[200],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 8.0),
                  child: TextFormField(
                    controller: _dateController,
                    readOnly: true,
                    onTap: () => _selectDate(context),
                    decoration: const InputDecoration(
                      hintText: 'Data da Carga',
                      border: InputBorder.none,
                      suffixIcon:
                          Icon(Icons.calendar_today, color: Colors.black54),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, selecione a data da carga';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        backgroundColor: Colors.grey[800],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Historico',
                          style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _salvarCarga,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        backgroundColor: Colors.green[800],
                        foregroundColor: Colors.white,
                      ),
                      child:
                          const Text('Salvar', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
