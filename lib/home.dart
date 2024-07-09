import 'package:flutter/material.dart';
import 'package:todo/models/todo.dart';
import 'package:todo/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _formGlobalKey=GlobalKey<FormState>();

  Priority _selectedPriority=Priority.low;
  String _title='';
  String _description='';

  //static todos
  final List<Todo> todos=[
    Todo(title: 'Buy Milk', description: 'There is no milk left in fridge.', priority: Priority.high),
    Todo(title: 'Make the bed', description: 'Keep things tidy please..', priority: Priority.low),
    Todo(title: 'Pay bills', description: 'The gas bill needs paying ASAP.', priority: Priority.urgent)
  ];

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
            Expanded(child: TodoList(todos: todos)),

            //form
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(21)
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formGlobalKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //title
                      TextFormField(
                        maxLength: 20,
                        decoration: const InputDecoration(
                          label: Text('Todo Title'),
                        ),
                        validator: (value) {
                          if(value==null||value.isEmpty){
                            return 'You must enter a value for the title';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _title=newValue!;
                        },
                      ),

                      //description
                      TextFormField(
                        maxLength: 20,
                        decoration: const InputDecoration(
                          labelText: 'Todo Description',
                        ),
                        validator: (value) {
                          if(value==null||value.isEmpty||value.length<5){
                            return 'Enter a description at least 5 characters long.';
                          }
                          return null;
                        },
                        onSaved: (newValue) {
                          _description=newValue!;
                        },
                      ),

                      //priority
                      DropdownButtonFormField(
                        value: _selectedPriority,
                        decoration: const InputDecoration(
                          labelText: 'Todo priority'
                        ),
                          items: Priority.values.map((e) {
                            return DropdownMenuItem(
                              value: e,
                              child: Text(e.title),
                            );
                          },).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedPriority=value!;
                            });
                          },
                      ),

                      //submit
                      const SizedBox(height: 20,),
                      FilledButton(
                          onPressed: (){
                            if(_formGlobalKey.currentState!.validate()){
                              _formGlobalKey.currentState!.save();

                              setState(() {
                                //dynamic todos
                                todos.add(Todo(
                                    title: _title,
                                    description: _description,
                                    priority: _selectedPriority
                                ));
                              });

                              _formGlobalKey.currentState!.reset();
                              _selectedPriority=Priority.low;
                            }
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Add')
                      )
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
