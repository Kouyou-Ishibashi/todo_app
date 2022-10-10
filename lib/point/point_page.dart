import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../children/child.dart';
import '../children/childrenlist_page.dart';
import '../children/mypage.dart';
import '../history/history_page.dart';
import '../payment/payment_page.dart';
import '../todo/todo_list_model.dart';
import '../todo/todo_list_page.dart';

// ignore: must_be_immutable
class PointPage extends StatelessWidget {
  final Child children;

  const PointPage(this.children, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ignore: dead_code
    return ChangeNotifierProvider<TodoListModel>(
      create: (_) => TodoListModel(children)..fetchPoint(),
      child: Scaffold(
          backgroundColor: Colors.teal,
          appBar: AppBar(
            title: const Text('ポイントページ'),
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
            child: Consumer<TodoListModel>(builder: (context, model, child) {
              final possessionPoints = model.possessionPoints;
              return Column(
                children: [
                  Text(
                    '所持ポイント',
                    style: GoogleFonts.pottaOne(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    child: Text(
                      possessionPoints.toString(),
                      style: GoogleFonts.pottaOne(
                        textStyle: Theme.of(context).textTheme.headline4,
                        fontSize: 100,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Text(
                    'ポイント',
                    style: GoogleFonts.pottaOne(
                      textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 50,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  children.possessionPoints != 0
                      ? ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    PaymentPage(children), // SecondPageは遷移先のクラス
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                              primary: Colors.blue,
                              elevation: 16,
                              minimumSize: const Size(100, 50),
                              backgroundColor: Colors.green //.withOpacity(0.5),
                              ),
                          child: const Text(
                            'ポイントを引き落とす',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontFamily: 'GenSenRounded',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : const Text(''),
                ],
              );
            }),
          )),
    );
  }
}
