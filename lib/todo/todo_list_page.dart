// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_app/todo/todo.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/todo/todo_list_model.dart';
import '../children/child.dart';
import '../children/childrenlist_page.dart';
import '../children/mypage.dart';
import '../history/history_page.dart';
import '../point/point_page.dart';
import '../todo_input/todo_input_page.dart';

// ignore: must_be_immutable
class TodoList extends StatelessWidget {
  final Child children;

  // ignore: use_key_in_widget_constructors
  const TodoList(this.children);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TodoListModel>(
      create: (_) => TodoListModel(children)..fetchTodoList(),
      child: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
            title: const Text('Todoリストページ'),
            backgroundColor: Colors.black87,
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return InputTodoPage(children);
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const Offset begin = Offset(0.0, 1.0);
                        const Offset end = Offset.zero;
                        final Animatable<Offset> tween =
                            Tween(begin: begin, end: end)
                                .chain(CurveTween(curve: Curves.easeInOut));
                        final Animation<Offset> offsetAnimation =
                            animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
                icon: const Icon(Icons.add_circle_outline_sharp),
              ),
            ]),
        drawer: SizedBox(
            width: 200,
            child: Drawer(
              child: ListView(
                children: [
                  SizedBox(
                    height: 50,
                    child: DrawerHeader(
                        decoration: const BoxDecoration(color: Colors.grey),
                        child: Text(
                          'User：${children.name}',
                          style: const TextStyle(
                              fontSize: 15, color: Colors.white),
                        )),
                  ),
                  ListTile(
                      title: const Text('チルドレン一覧'),
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return const ChildrenList();
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const Offset begin = Offset(-1.0, 0.0); // 右から左
                              const Offset end = Offset.zero;
                              final Animatable<Offset> tween = Tween(
                                      begin: begin, end: end)
                                  .chain(CurveTween(curve: Curves.easeInOut));
                              final Animation<Offset> offsetAnimation =
                                  animation.drive(tween);
                              return SlideTransition(
                                position: offsetAnimation,
                                child: child,
                              );
                            },
                          ),
                        );
                      }),
                  ListTile(
                    title: const Text('マイページ'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return Mypage(children);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Todoリストページ'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return TodoList(children);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('Todo履歴ページ'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return HistoryList(children);
                          },
                        ),
                      );
                    },
                  ),
                  ListTile(
                    title: const Text('ポイントページ'),
                    onTap: () {
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder:
                              (context, animation, secondaryAnimation) {
                            return PointPage(children);
                          },
                        ),
                      );
                    },
                  )
                ],
              ),
            )),
        body: Center(
          child: Consumer<TodoListModel>(builder: (context, model, child) {
            final List<Todo>? todos = model.todos;

            if (todos == null) {
              return const Text('Todoなし');
            }

            final List<Widget> widgets = todos
                .map((todo) => Slidable(
                      // 左スライド表示
                      startActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            label: '達成',
                            backgroundColor: Colors.blue,
                            icon: Icons.thumb_up,
                            onPressed: (value) async {
                              await clearConfirmDialog(context, todo, model);
                            },
                          ),
                        ],
                      ),

                      // 右スライド表示
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            label: '削除',
                            backgroundColor: Colors.redAccent,
                            icon: Icons.delete,
                            onPressed: (value) async {
                              await showConfirmDialog(context, todo, model);
                            },
                          ),
                        ],
                      ),

                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.teal,
                        ),
                        child: ListTile(
                          title: Text(
                            todo.title,
                            style: const TextStyle(
                                fontSize: 25, color: Colors.white),
                          ),
                          subtitle: Text(
                            '作成日：${todo.createDate}',
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: Text(
                            '${todo.point.toString()} P',
                            style: const TextStyle(
                                fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                    ))
                .toList();
            return ListView(
              children: widgets,
            );
          }),
        ),
      ),
    );
  }

  //削除スライド
  Future showConfirmDialog(
    BuildContext context,
    Todo todo,
    TodoListModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text("『${todo.title}』を削除しますか？"),
          actions: [
            TextButton(
              child: const Text("いいえ"),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("はい"),
              onPressed: () async {
                await model.delete(todo);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TodoList(children), // SecondPageは遷移先のクラス
                  ),
                );
                final snackBar = SnackBar(
                  duration: const Duration(milliseconds: 1000),
                  backgroundColor: Colors.brown,
                  content: Text('${todo.title}を削除しました'),
                );
                model.fetchTodoList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }

  //達成スライド設定
  Future clearConfirmDialog(
    BuildContext context,
    Todo todo,
    TodoListModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("達成の確認"),
          content: Text("『${todo.title}』のTodo実施しましたか？"),
          actions: [
            TextButton(
              child: const Text("いいえ"),
              onPressed: () =>
                  Navigator.of(context, rootNavigator: true).pop('No'),
            ),
            TextButton(
              child: const Text("はい"),
              onPressed: () async {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TodoList(children), // SecondPageは遷移先のクラス
                  ),
                );
                //Todo実施完了した場合、所持ポイントにTodoポイント追加した値に更新、Todoテーブルから削除
                await model.update(todo);
                final snackBar = SnackBar(
                  duration: const Duration(milliseconds: 1000),
                  backgroundColor: Colors.blue,
                  content: Text('${todo.title}を実施しました!'),
                );
                // model.fetchTodoList();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
