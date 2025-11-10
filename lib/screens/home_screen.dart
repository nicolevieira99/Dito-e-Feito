import 'package:flutter/material.dart';
import 'add_task_screen.dart';
import 'edit_task_screen.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tarefas = [];

  void adicionarTarefa(String novaTarefa) {
    setState(() {
      tarefas.add(Task(titulo: novaTarefa));
    });
  }

  void editarTarefa(int index, String novoTexto) {
    setState(() {
      tarefas[index].titulo = novoTexto;
    });
  }

  void excluirTarefa(int index) {
    setState(() {
      tarefas.removeAt(index);
    });
  }

  void marcarComoConcluida(int index, bool valor) {
    setState(() {
      tarefas[index].concluida = valor;
    });
  }

  void abrirTelaAdicionar() async {
    final novaTarefa = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddTaskScreen()),
    );
    if (novaTarefa != null) adicionarTarefa(novaTarefa);
  }

  void abrirTelaEditar(int index) async {
    final tarefaEditada = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditTaskScreen(
          textoInicial: tarefas[index].titulo,
        ),
      ),
    );
    if (tarefaEditada != null) editarTarefa(index, tarefaEditada);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dito e Feito'),
        centerTitle: true,
      ),
      body: tarefas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa ainda. Adicione uma!',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: tarefas.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: ListTile(
                    leading: Checkbox(
                      value: tarefas[index].concluida,
                      onChanged: (valor) => marcarComoConcluida(index, valor!),
                    ),
                    title: Text(
                      tarefas[index].titulo,
                      style: TextStyle(
                        decoration: tarefas[index].concluida
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.deepPurple),
                          onPressed: () => abrirTelaEditar(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => excluirTarefa(index),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: abrirTelaAdicionar,
        child: const Icon(Icons.add),
      ),
    );
  }
}