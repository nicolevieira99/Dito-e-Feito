import 'package:flutter/material.dart';
import '../models/task.dart';

class HomeScreen extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleDarkMode;

  const HomeScreen({
    Key? key,
    required this.isDarkMode,
    required this.onToggleDarkMode,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Task> _tasks = [];
  bool _creatingTask = false;
  Task? _editingTask;
  final TextEditingController _controller = TextEditingController();
  Color _selectedColor = Colors.deepPurple.shade200;
  String _selectedUrgency = 'Normal';

  final List<String> urgencies = ['Baixa', 'Normal', 'Alta'];
  final List<Color> colors = [
    Colors.deepPurple.shade200,
    Colors.pink.shade200,
    Colors.blue.shade200,
    Colors.green.shade200,
    Colors.orange.shade200
  ];

  void _startAddTask() {
    setState(() {
      _creatingTask = true;
      _editingTask = null;
      _controller.clear();
      _selectedColor = colors.first;
      _selectedUrgency = 'Normal';
    });
  }

  void _confirmTask() {
    if (_controller.text.trim().isEmpty) return;
    if (_editingTask != null) {
      setState(() {
        _editingTask!.title = _controller.text.trim();
        _editingTask!.color = _selectedColor;
        _editingTask!.urgency = _selectedUrgency;
        _creatingTask = false;
        _editingTask = null;
        _controller.clear();
      });
    } else {
      setState(() {
        _tasks.add(Task(
          title: _controller.text.trim(),
          color: _selectedColor,
          urgency: _selectedUrgency,
        ));
        _creatingTask = false;
        _controller.clear();
      });
    }
  }

  void _cancelTask() {
    setState(() {
      _creatingTask = false;
      _editingTask = null;
      _controller.clear();
      _selectedColor = colors.first;
      _selectedUrgency = 'Normal';
    });
  }

  void _editTask(Task task) {
    setState(() {
      _editingTask = task;
      _controller.text = task.title;
      _selectedColor = task.color;
      _selectedUrgency = task.urgency;
      _creatingTask = true;
    });
  }

  void _deleteTask(Task task) {
    setState(() => _tasks.remove(task));
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;
    return Scaffold(
      appBar: AppBar(
        title: Text('Dito e Feito (${_tasks.where((t) => !t.isDone).length} pendentes)'),
        actions: [
          IconButton(
            icon: Icon(isDark ? Icons.wb_sunny : Icons.dark_mode),
            onPressed: widget.onToggleDarkMode,
          ),
        ],
      ),
      body: Column(
        children: [
          if (_creatingTask)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Título da tarefa',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Dropdown de urgência (seta padrão do Flutter)
                      DropdownButton<String>(
                        value: _selectedUrgency,
                        items: urgencies
                            .map((u) => DropdownMenuItem(
                                  value: u,
                                  child: Text(u),
                                ))
                            .toList(),
                        onChanged: (value) {
                          if (value != null) setState(() => _selectedUrgency = value);
                        },
                      ),

                      // Paleta de cores com ícone pincel quando selecionada
                      Row(
                        children: colors.map((color) {
                          final selected = color == _selectedColor;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedColor = color),
                            child: Container(
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: color,
                                border: Border.all(
                                  color: selected
                                      ? (isDark ? Colors.white : Colors.black)
                                      : Colors.transparent,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: selected
                                  ? Center(
                                      child: Icon(
                                        Icons.brush,
                                        size: 16,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                    )
                                  : null,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Botões Confirmar / Cancelar padronizados com ícones
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _confirmTask,
                          icon: Icon(Icons.check, color: isDark ? Colors.white : Colors.black),
                          label: Text('Confirmar', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: isDark ? Colors.white : Colors.black, width: 1.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _cancelTask,
                          icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
                          label: Text('Cancelar', style: TextStyle(color: isDark ? Colors.white : Colors.black)),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: isDark ? Colors.white : Colors.black, width: 1.4),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

          // Lista de tarefas
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  color: task.isDone
                      ? Colors.grey.shade700
                      : task.color.withOpacity(isDark ? 0.7 : 0.9),
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  child: ListTile(
                    title: Text(
                      task.title,
                      style: TextStyle(
                        decoration: task.isDone ? TextDecoration.lineThrough : null,
                        color: isDark && !task.isDone ? Colors.white : null,
                      ),
                    ),
                    subtitle: Text(
                      'Urgência: ${task.urgency}',
                      style: TextStyle(
                        color: isDark && !task.isDone ? Colors.white70 : null,
                      ),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Checkbox(
                          value: task.isDone,
                          onChanged: (value) => setState(() => task.isDone = value!),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: isDark ? Colors.white : Colors.black),
                          onPressed: () => _editTask(task),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: isDark ? Colors.white : Colors.black),
                          onPressed: () => _deleteTask(task),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: !_creatingTask
          ? FloatingActionButton(
              onPressed: _startAddTask,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
