import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({super.key, required this.todos});

  final List<Todo> todos;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (context, index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: widget.todos[index].priority.color.withOpacity(.5),
          ),
          padding: const EdgeInsets.only(left: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.todos[index].title,style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(widget.todos[index].description,),
                ],
              ),
              Container(
                width: 90,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: widget.todos[index].priority.color
                ),
                child: Center(child: Text(widget.todos[index].priority.title)),
              )
            ],
          ),
        ),
      );
    },);
  }
}
