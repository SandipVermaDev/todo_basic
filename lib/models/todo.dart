import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum Priority {
  urgent(color: Colors.red, title: 'Urgent'),
  high(color: Colors.orange, title: 'High'),
  medium(color: Colors.amber, title: 'Medium'),
  low(color: Colors.green, title: 'Low');

  const Priority({required this.color, required this.title});

  final Color color;
  final String title;
}

class Todo {
  Todo({
    required this.title,
    required this.description,
    required this.priority,
    required this.time,
    this.reference,
  });

  final String title;
  final String description;
  final Priority priority;
  final DateTime time;
  final DocumentReference? reference;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'priority': priority.index,
      'time': time.toIso8601String(),
    };
  }

  static Todo fromMap(Map<String, dynamic> map, DocumentReference reference) {
    return Todo(
      title: map['title'],
      description: map['description'],
      priority: Priority.values[map['priority']],
      time: DateTime.parse(map['time']),
      reference: reference,
    );
  }
}
