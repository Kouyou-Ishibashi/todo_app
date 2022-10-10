import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/children/child.dart';
import 'package:todo_app/children/childrenlist_model.dart';
import '../child_edit/child_edit_page.dart';
import '../main.dart';
import '../child_add/child_add_page.dart';
import '../todo/todo_list_page.dart';

class ChildrenList extends StatefulWidget {
  const ChildrenList({Key? key}) : super(key: key);

  @override
  State<ChildrenList> createState() => _ChildrenList();
}

class _ChildrenList extends State<ChildrenList> {
// ログアウト用ログイン情報ユーザー取得
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ChildrenProviderModel>(
      create: (_) => ChildrenProviderModel()..fetchChildrenList(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('チルドレン一覧'),
          backgroundColor: Colors.black87,
          // ログアウトボタン(ダイアログが表示される)
          leading: IconButton(
            icon: const Icon(Icons.output_sharp),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) => CupertinoAlertDialog(
                        title: const Text("ログアウトしますか？"),
                        actions: [
                          CupertinoDialogAction(
                              isDestructiveAction: true,
                              onPressed: () {},
                              child: const Text('Cancel')),
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () {
                              _auth.signOut();
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyApp()));
                            },
                          )
                        ],
                      ));
            },
          ),
          // ユーザー追加ボタン
          actions: [
            IconButton(
                icon: const Icon(Icons.add_reaction_outlined),
                onPressed: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) {
                        return const AddUserPage();
                      },
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const Offset begin = Offset(0.0, 0.5); // 下から上
                        // final Offset begin = Offset(0.0, -1.0); // 上から下
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
                }),
          ],
        ),
        body: Center(
          child:
              Consumer<ChildrenProviderModel>(builder: (context, model, child) {
            final List<Child>? children = model.children;

            if (children == null) {
              return const Text('登録者なし');
            }

            final List<Widget> widgets = children
                .map((children) => Slidable(
                      endActionPane: ActionPane(
                        motion: const DrawerMotion(),
                        children: [
                          SlidableAction(
                            label: '編集',
                            backgroundColor: Colors.black45,
                            icon: Icons.edit,
                            onPressed: (value) async {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditChildPage(children),
                                ),
                              );
                            },
                          ),
                          SlidableAction(
                            label: '削除',
                            backgroundColor: Colors.redAccent,
                            icon: Icons.delete,
                            onPressed: (value) async {
                              // 削除しますか？って聞いて、はいだったら削除
                              await showConfirmDialog(context, children, model);
                            },
                          ),
                        ],
                      ),
                      child: Container(
                        //margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black12),
                        ),
                        padding: const EdgeInsets.only(top: 5, bottom: 5),
                        child: ListTile(
                          // ignore: unnecessary_null_comparison
                          leading: children.imgUrl != ''
                              ? SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(200),
                                    child: Image.network(
                                      children.imgUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "images/upper_body-1.jpg"))),
                                  ),
                                ),
                          title: Text(children.name),
                          subtitle: Text(children.relationship),
                          trailing: Text(
                            '${children.possessionPoints.toString()} P',
                            style: const TextStyle(fontSize: 20),
                          ),
                          onTap: () => {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    TodoList(children),
                              ),
                            ),
                          },
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

  Future showConfirmDialog(
    BuildContext context,
    Child child,
    ChildrenProviderModel model,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          title: const Text("削除の確認"),
          content: Text("『${child.name}』を削除しますか？"),
          actions: [
            OutlinedButton(
              child: const Text(
                "No",
                style: TextStyle(color: Colors.black45),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            OutlinedButton(
              child: const Text(
                "Yes",
                style: TextStyle(color: Colors.black45),
              ),
              onPressed: () async {
                // modelで削除
                await model.deleteUser(child);
                // ignore: use_build_context_synchronously
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return const ChildrenList();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      const double begin = 0.0;
                      const double end = 1.0;
                      final Animatable<double> tween =
                          Tween(begin: begin, end: end)
                              .chain(CurveTween(curve: Curves.easeInOut));
                      final Animation<double> doubleAnimation =
                          animation.drive(tween);
                      return FadeTransition(
                        opacity: doubleAnimation,
                        child: child,
                      );
                    },
                  ),
                );
                final snackBar = SnackBar(
                  duration: const Duration(milliseconds: 1000),
                  backgroundColor: Colors.brown,
                  content: Text('${child.name}を削除しました'),
                );
                model.fetchChildrenList();
                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
            ),
          ],
        );
      },
    );
  }
}
