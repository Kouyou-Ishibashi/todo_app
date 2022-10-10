import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/children/child.dart';
import '../todo/todo_list_model.dart';
import '../todo/todo_list_page.dart';

class InputTodoPage extends StatelessWidget {
  final Child children;

  // ignore: use_key_in_widget_constructors
  const InputTodoPage(this.children);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoListModel>(
      create: (_) => TodoListModel(children),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Todo追加'),
          backgroundColor: Colors.black87,
        ),
        body: Center(
          child: Consumer<TodoListModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  TextField(
                    maxLength: 15,
                    decoration: const InputDecoration(
                      hintText: 'Todoタイトル',
                    ),
                    onChanged: (text) {
                      model.title = text;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      hintText: 'クリアポイント数',
                    ),
                    onChanged: (text) {
                      model.point = int.parse(text);
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // 追加の処理
                      try {
                        await model.inputTodo();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                TodoList(children),
                          ),
                        );
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('追加する'),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
