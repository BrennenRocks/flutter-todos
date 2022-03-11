import 'dart:async';

import '../models/todo.dart';

class TodoStreamService {
  final _socketResponse = StreamController<List<Todo>>();

  void Function(List<Todo>) get addTodo => _socketResponse.sink.add;

  Stream<List<Todo>> get getStream => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}