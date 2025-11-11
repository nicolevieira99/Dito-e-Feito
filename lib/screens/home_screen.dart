import 'package:flutter/material.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> tarefas = [];

  void _adicionarTarefa(String titulo) {
    if (titulo.isEmpty) return;
    setState(() {
      tarefas.add(Task(titulo: titulo));
    });
  }

  void _removerTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  void _toggleTarefa(int index) {
    setState(() {
      tarefas[index].concluida = !tarefas[index].concluida;
    });
  }

  void _mostrarDialog() {
    String novaTarefa = '';
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nova Tarefa'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Digite a tarefa',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) => novaTarefa = value,
          onSubmitted: (_) {
            _adicionarTarefa(novaTarefa);
            Navigator.of(context).pop();
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              _adicionarTarefa(novaTarefa);
              Navigator.of(context).pop();
            },
            child: const Text('Adicionar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dito e Feito'),
        backgroundColor: Colors.blueAccent,
      ),
      body: tarefas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa ainda!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = tarefas[index];
                return Card(
                  color: tarefa.concluida ? Colors.grey[300] : Colors.blue[50],
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarefa.concluida,
                      onChanged: (_) => _toggleTarefa(index),
                      activeColor: Colors.green,
                    ),
                    title: AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 300),
                      style: TextStyle(
                        decoration: tarefa.concluida
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: tarefa.concluida ? Colors.grey : Colors.black,
                        fontSize: 18,
                      ),
                      child: Text(tarefa.titulo),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removerTarefa(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _mostrarDialog,
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, size: 32),
      ),
    );
  }
}
