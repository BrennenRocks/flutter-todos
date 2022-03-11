import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:todos/ui/startup/startup_viewmodel.dart';

class TodoListTile extends ViewModelWidget<StartUpViewModel> {
  final int index;

  const TodoListTile(this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, StartUpViewModel viewModel) {
    return ResponsiveWrapper.of(context).isSmallerThan(DESKTOP)
      ? Dismissible(
          background: Container(color: Colors.red),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) => viewModel.deleteTodo(index),
          key: Key(viewModel.todoList[index].id!),
          child: row(index, viewModel, false),
        )
      : row(index, viewModel, true);
  }
}

Widget row(int index, StartUpViewModel viewModel, bool showDeleteButton) {
  return Row(
    children: [
      Checkbox(value: viewModel.todoList[index].isDone, onChanged: (checked) => viewModel.markDone(index, checked)),
      Text(viewModel.todoList[index].text),
      showDeleteButton ? IconButton(onPressed: () => viewModel.deleteTodo(index), icon: const Icon(Icons.delete), color: Colors.red) : Container(),
    ],
  );
}