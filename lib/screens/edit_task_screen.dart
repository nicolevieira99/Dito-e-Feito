import 'package:flutter/material.dart';

class EditTaskScreen extends StatefulWidget {
  final String textoInicial;

  EditTaskScreen({required this.textoInicial});

  @override
  _EditTaskScreenState createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.textoInicial);
  }

  void salvar() {
    final texto = _controller.text.trim();
    if (texto.isNotEmpty) {
      Navigator.pop(context, texto);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Editar tarefa'),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: salvar,
                  child: const Text('Salvar'),
                ),
                OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}