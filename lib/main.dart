import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/firebase_options.dart';
import 'package:todo/screens/home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'TODO App',
      home: Home(),
    );
  }
}


/*
void _resetForm() {
    setState(() {
      _title = '';
      _description = '';
      _selectedPriority = Priority.low;
      _selectedDateTime = null;
      _submitButtonText = 'Add';
      _currentTodoRef = null;
    });

    // Delay clearing text controllers after current build cycle
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _titleController.clear();  // Clear the text field for title
      _descriptionController.clear();  // Clear the text field for description
    });

    _formGlobalKey.currentState?.reset();  // Reset the form state
  }
 */