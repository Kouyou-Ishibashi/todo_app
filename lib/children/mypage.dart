import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/children/child.dart';
import 'package:todo_app/children/childrenlist_model.dart';
import '../child_edit/child_edit_page.dart';
import '../history/history_page.dart';
import '../point/point_page.dart';
import '../todo/todo_list_page.dart';
import 'childrenlist_page.dart';

class Mypage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const Mypage(this.children);

  final Child children;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChildrenProviderModel>(
      create: (_) => ChildrenProviderModel()..fetchChildrenList(),
      // ignore: sort_child_properties_last
      child: Scaffold(
          appBar: AppBar(
            title: const Text('マイページ'),
            backgroundColor: Colors.black87,
            // ログアウトボタン(ダイアログが表示される)
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
                            style: const TextStyle(fontSize: 15),
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
            child: Column(
              children: [
                const SizedBox(
                  height: 100,
                ),
                Container(
                  child: children.imgUrl != ''
                      ? SizedBox(
                          width: 200,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            child: Image.network(
                              children.imgUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                        )
                      : SizedBox(
                          width: 200,
                          height: 200,
                          child: Container(
                            decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image:
                                        AssetImage("images/upper_body-1.jpg"))),
                          ),
                        ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Text(
                  children.name,
                  style: const TextStyle(fontSize: 50),
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  children.relationship,
                  style: const TextStyle(fontSize: 25),
                ),
                const SizedBox(
                  height: 25,
                ),
                SizedBox(
                    width: 200,
                    child: ElevatedButton(
                        onPressed: () async {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditChildPage(children),
                            ),
                          );
                        },
                        child: const Text('編集する')))
              ],
            ),
          )),
    );
  }
}
