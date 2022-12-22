import 'dart:convert';
import 'package:flutter/material.dart';
import '../create_todo.dart';
import '../update_todo.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

const String baseURL = 'https://jsonplaceholder.typicode.com/todos';

class _HomePageState extends State<HomePage> {
  List getResponse = <dynamic>[];

  getTodo() async {
    var url = Uri.parse(baseURL);
    var response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        getResponse = jsonDecode(response.body) as List<dynamic>;
      });
    } else {
      return null;
    }
  }

  deleteTodo(var todo) async {
    var url = Uri.parse('$baseURL/${todo["id"]}');
    var response = await http.delete(url);

    if (response.statusCode == 200) {
      print('Successfully deleted task: ${todo["title"]} ID: ${todo["id"]}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.white,
        content: Text(
            'Successfully deleted task: ${todo["title"]} ID: ${todo["id"]}'),
        action: SnackBarAction(
            label: 'Dismiss',
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
            }),
      ));
    } else {
      return null;
    }
  }

  putTodo(var todo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.lightBlueAccent,
        content: Text(
            'Successfully edited task:'
                ' ${todo["title"]} ID: '
                '${todo["id"]}')));
  }

  postTodo(var todo) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.lightBlueAccent,
        content: Text(
            'Successfully created task:'
                ' ${todo["title"]} ID: '
                '${todo["id"]}')));
  }


  @override
  void initState() {
    getTodo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TODO LIST'),
        centerTitle: true,
        titleTextStyle: const TextStyle(
          fontSize: 20,
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: getResponse.length,
        itemBuilder: (context, index) {
          return Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.endToStart,
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.delete, size: 20,
                ),
              ),
              child: CheckboxListTile(
                title: Text('${getResponse[index]['title']}'),
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: Colors.blueAccent,
                secondary: IconButton(
                  onPressed: () async {
                    var check = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                UpdateTodo(todo: getResponse[index])));
                    if (check != null) {
                      putTodo(getResponse[index]);
                    } else {
                      print('No changes were made');
                    }
                  },
                  tooltip: 'Edit',
                  icon: const Icon(Icons.edit, size: 20,),
                  color: Colors.blue,
                ),

                value: getResponse[index]['completed'],
                onChanged: (bool? value) {
                  setState(() {
                    getResponse[index]['completed'] = value!;
                  });
                },
              ),
              onDismissed: (direction) =>
                  setState(() {
                    deleteTodo(getResponse[index]);
                    getResponse.removeAt(index);
                  })
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (_) => const CreateTodo(),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
