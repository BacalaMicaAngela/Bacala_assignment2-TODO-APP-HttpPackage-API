import 'dart:convert';


Todos taskFromJson(String str) => Todos.fromJson(json.decode(str));

String taskToJson(Todos data) => json.encode(data.toJson());

class Todos {
  Todos({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  int? userId;
  int? id;
  String? title;
  bool? completed;

  factory Todos.fromJson(Map<String, dynamic> json) => Todos(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
  };
}