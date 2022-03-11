import 'dart:math';

import 'package:http/http.dart' as http;
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:stacked/stacked.dart';

import '../../core/models/todo.dart';

class StartUpViewModel extends BaseViewModel {
  List<String> randomTodos = ['Vacuum the room', 'Feed the thing', 'Clean the stuff', 'Go to that place', 'Read the book', 'Help mother'];
  List<Todo> _todoList = [];
  List<Todo> get todoList => _todoList;

  void initSocketConnection() async {
    try {
      IO.Socket socket = IO.io('https://nestjs-todos.herokuapp.com', IO.OptionBuilder().setTransports(['websocket']).build());

      socket.on('connection', (data) {
        _todoList = (data as List<dynamic>).map((todo) => Todo.fromJson(todo)).toList();
        notifyListeners();
      });

      socket.on('newTodo', (data) {
        _todoList.add(Todo.fromJson(data));
        notifyListeners();
      });

      socket.on('updateTodo', (data) {
        Todo updated = Todo.fromJson(data);
        int index = _todoList.indexWhere((element) => element.id == updated.id);
        _todoList[index] = updated;
        notifyListeners();
      });

      socket.on('deleteTodo', (data) {
        _todoList.removeWhere((element) => element.id == data);
        notifyListeners();
      });
    } catch (e) {
      print(e.toString());
    }
  }

  void markDone(int index, bool? checked) async {
    _todoList[index].isDone = checked!;
    notifyListeners();

    var url = Uri.parse('https://nestjs-todos.herokuapp.com/todos/${_todoList[index].id}');
    await http.put(url, body: _todoList[index].toJson());
  }

  void newTodo() async {
    final _random = Random();
    int randomIndex = _random.nextInt(randomTodos.length);
    Todo todo = Todo(randomTodos[randomIndex], false);
    var url = Uri.parse('https://nestjs-todos.herokuapp.com/todos');
    await http.post(url, body: todo.toJson());
  }

  void deleteTodo(int index) async {
    var url = Uri.parse('https://nestjs-todos.herokuapp.com/todos/${_todoList[index].id}');
    await http.delete(url);
  }
}