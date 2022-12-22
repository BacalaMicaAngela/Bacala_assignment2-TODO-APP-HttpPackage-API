import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'model/todo_model.dart';

class CreateTodo extends StatefulWidget {
  const CreateTodo({Key? key}) : super(key: key);

  @override
  State<CreateTodo> createState() => _CreateTodoState();
}
const String baseUrl = 'https://jsonplaceholder.typicode.com/todos';

Future<Todos?> addData(String title, bool status) async {
  var url = Uri.parse(baseUrl);
  var bodyData = json.encode({'title': title, 'completed': status});
  var response = await http.post(url, body: bodyData);

  if (response.statusCode == 201) {
    print('Successfully added a task!');
    var displayNewTask = response.body;
    print(displayNewTask);

    String todoResponse = response.body;
    taskFromJson(todoResponse);
  } else {
    return null;
  }
  return null;
}

class _CreateTodoState extends State<CreateTodo> {
  Todos? task;

  var newTaskController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add To do'),
        centerTitle: true,
      ),
      body: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              child: TextFormField(
                controller: newTaskController,
                decoration: const InputDecoration(
                  icon: Icon(Icons.check_circle_outlined),
                  hintText: 'New Task',
                  labelText: 'Task',
                ),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.done,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Insert a text';
                  } else {
                    return null;
                  }
                },
              ),
            ),
            SizedBox(
              height: 40,
              width: 10,
              child: ElevatedButton(
                  child: const Text(
                    'Create New',
                  ),
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      Todos? data = await addData(newTaskController.text, false);
                      setState(() {
                        task = data;
                      });
                    } else {
                      return;
                    }
                    Navigator.pop(context);
                  }),
            ),
          ],
        ),
      ),
    );
  }
}