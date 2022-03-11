import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:stacked/stacked.dart';
import 'package:todos/ui/startup/startup_viewmodel.dart';
import 'package:todos/ui/startup/widgets/todo_list_tile.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: ((model) => model.initSocketConnection()),
      builder: (context, viewModel, child) => Scaffold(
        appBar: AppBar(
          title: const Text('Todos'),
        ),
        floatingActionButton: ResponsiveWrapper.of(context).isSmallerThan(DESKTOP) ? FloatingActionButton(onPressed: () => viewModel.newTodo(), child: const Icon(Icons.add),) : null,
        body: ResponsiveWrapper.of(context).isLargerThan(TABLET)
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.green), foregroundColor: MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () => viewModel.newTodo(),
                    child: const Text('New Todo'),
                  ),
                  Expanded(child: listView(viewModel),),
                ],
              )
          : listView(viewModel),
      ),
      viewModelBuilder: () => StartUpViewModel(),
    );
  }
}

Widget listView(StartUpViewModel viewModel) {
  return ListView.builder(
    padding: const EdgeInsets.all(8),
    itemCount: viewModel.todoList.length,
    itemBuilder: (BuildContext context, int index) {
      return TodoListTile(index);
    },
  );
}