import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/screens/todo_list.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formGlobalKey = GlobalKey<FormState>();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  Priority _selectedPriority = Priority.low;
  String _title = '';
  String _description = '';
  DateTime? _selectedDateTime;
  String _submitButtonText = 'Add';
  DocumentReference? _currentTodoRef;

  Stream<List<Todo>> getTodos() {
    return _firestore.collection('todos').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Todo.fromMap(doc.data(), doc.reference)).toList());
  }

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day,
              pickedTime.hour, pickedTime.minute);
        });
      }
    }
  }

  void _updateForm(Todo todo) {
    setState(() {
      _title = todo.title;
      _description = todo.description;
      _selectedPriority = todo.priority;
      _selectedDateTime = todo.time;
      _submitButtonText = 'Update';
      _currentTodoRef = todo.reference;
      _titleController.text = todo.title;
      _descriptionController.text = todo.description;
    });
  }

  void _resetForm() {
    setState(() {
      _title = '';
      _description = '';
      _selectedPriority = Priority.low;
      _selectedDateTime = null;
      _submitButtonText = 'Add';
      _currentTodoRef = null;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleController.clear();
      _descriptionController.clear();
    });

    _formGlobalKey.currentState?.reset();
  }

  Future<void> _handleSubmit() async {
    if (_formGlobalKey.currentState!.validate()) {
      _formGlobalKey.currentState!.save();
      final newTodo = Todo(
        title: _title,
        description: _description,
        priority: _selectedPriority,
        time: _selectedDateTime!,
      );
      if (_currentTodoRef != null) {
        await _currentTodoRef!.update(newTodo.toMap());
      } else {
        final DocumentReference docRef =
        await _firestore.collection('todos').add(newTodo.toMap());
        _currentTodoRef = docRef;
      }
      _resetForm();

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO List'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<Todo>>(
                stream: getTodos(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error fetching todos'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No todos available'));
                  }
                  return TodoList(
                    todos: snapshot.data!,
                    onDelete: (todo) async {
                      await todo.reference?.delete();
                    },
                    onUpdate: (todo) {
                      _updateForm(todo);
                    },
                  );
                },
              ),
            ),
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: _titleController,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          label: Text('Todo Title'),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must enter a value for the title';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _title = newValue!;
                        },
                      ),
                      TextFormField(
                        controller: _descriptionController,
                        maxLength: 20,
                        decoration: const InputDecoration(
                          labelText: 'Todo Description',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty || value.length < 5) {
                            return 'Enter a description at least 5 characters long.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _description = newValue!;
                        },
                      ),
                      DropdownButtonFormField<Priority>(
                        value: _selectedPriority,
                        decoration: const InputDecoration(labelText: 'Todo priority'),
                        items: Priority.values.map((priority) {
                          return DropdownMenuItem<Priority>(
                            value: priority,
                            child: Text(priority.title),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedPriority = value!;
                          });
                        },
                      ),
                      TextFormField(
                        readOnly: true,
                        decoration: const InputDecoration(labelText: 'Due Date and Time'),
                        onTap: () => _selectDateTime(context),
                        controller: TextEditingController(
                          text: _selectedDateTime != null ? _selectedDateTime.toString() : '',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'You must select a due date and time';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: _handleSubmit,
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.grey[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(_submitButtonText),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
