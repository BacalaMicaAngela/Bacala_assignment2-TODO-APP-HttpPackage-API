
import '../model/todo_model.dart';

abstract class Repository {

  getTodo();
  deleteTodo(var todo);
  putTodo(var todo);
  postTodo(var todo);

}