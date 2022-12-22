import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class UpdateTodo extends StatefulWidget {
  final dynamic todo;

  const UpdateTodo({Key? key, this.todo}) : super(key: key);

  @override
  State<UpdateTodo> createState() => _UpdateTodoState();
}
String baseURL = 'https://jsonplaceholder.typicode.com/todos';

class _UpdateTodoState extends State<UpdateTodo> {

  var id = '';
  var check;

  final todoController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    todoController.text = widget.todo["title"];
    id = widget.todo["id"].toString();
    check = widget.todo["title"];
  }

  editUser() async {
    var newTitle = todoController.text;
    var url = Uri.parse('$baseURL/$id');
    var bodyData = json.encode({
      'title': newTitle,
    });
    var response = await http.put(url, body: bodyData);
    if (response.statusCode == 200) {
      print('\nSuccessfully edited Task id: $id!');
      var display = response.body;
      print(display);
    } else {
      return null;
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Task'),
          centerTitle: true,
          titleTextStyle: const TextStyle(
            fontSize: 20,
          ),
        ),
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.all(12),
            children: [
              TextFormField(
                controller: todoController,
                keyboardType: TextInputType.text,
                decoration: const InputDecoration(
                  hintText: 'Add Todo',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Add new task';
                  } else {
                    return null;
                  }
                },
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(40.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      if (check != todoController.text) {
                        await editUser();
                        Navigator.pop(context, check);
                      } else {
                        return;
                      }
                    } else {
                      return;
                    }
                  },
                  child: const Text('Update The Task',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }
}