import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../children/child.dart';
import '../children/childrenlist_page.dart';
import '../children/mypage.dart';
import '../point/point_page.dart';
import '../todo/todo_list_page.dart';
import 'history.dart';
import 'history_model.dart';

class HistoryList extends StatelessWidget {
  final Child children;

  // ignore: use_key_in_widget_constructors
  const HistoryList(this.children);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HistoryListModel>(
      create: (_) => HistoryListModel(children)..fetchHistoryList(),
      child: Scaffold(
        backgroundColor: Colors.teal,
        appBar: AppBar(
          title: const Text('Todo履歴ページ'),
          backgroundColor: Colors.black87,
        ),
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
          child: Consumer<HistoryListModel>(builder: (context, model, child) {
            final List<History>? history = model.histories;
            if (history == null) {
              return const Text('達成履歴なし');
            }
            final List<Widget> widgets = history
                .map((history) => Slidable(
                      child: history.useJudgeFlg == '0'
                          ? Container(
                              margin: const EdgeInsets.all(5),
                              decoration:
                                  const BoxDecoration(color: Colors.grey),
                              child: ListTile(
                                title: Text(
                                  history.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                subtitle: Text('達成日：${history.dateTime}'),
                                trailing: Text(
                                  '${history.point}P',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                            )
                          : Container(
                              margin: const EdgeInsets.all(5),
                              decoration:
                                  const BoxDecoration(color: Colors.pinkAccent),
                              child: ListTile(
                                title: Text(
                                  history.title,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                subtitle: Text('引落日：${history.dateTime}'),
                                trailing: Text(
                                  '- ${history.point}P',
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 20),
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
}
