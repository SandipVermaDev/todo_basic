import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
    required this.todos,
    required this.onDelete,
    required this.onUpdate,
  });

  final List<Todo> todos;
  final Function(Todo) onDelete;
  final Function(Todo) onUpdate;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd HH:mm');

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (context, index) {
        final todo = widget.todos[index];
        return GestureDetector(
          onLongPress: () => _showOptions(context, todo),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: todo.priority.color.withOpacity(.5),
              ),
              padding: const EdgeInsets.only(left: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(todo.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(todo.description),
                      Text('Due: ${_dateFormat.format(todo.time)}'),  // Format and display due time
                    ],
                  ),
                  Container(
                    width: 90,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: todo.priority.color,
                    ),
                    child: Center(child: Text(todo.priority.title)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showOptions(BuildContext context, Todo todo) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return ListTile(
          title: const Text('Options'),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _confirmDelete(context, todo);
                },
                child: const Text('Delete'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onUpdate(todo);
                },
                child: const Text('Update'),
              ),
            ],
          ),
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, Todo todo) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this todo?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onDelete(todo);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
