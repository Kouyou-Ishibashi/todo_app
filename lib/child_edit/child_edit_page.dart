import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../child_add/child_add_model.dart';
import '../children/child.dart';
import '../children/mypage.dart';
import '../loading_dialog.dart';

class EditChildPage extends StatefulWidget {
  final Child child;

  // ignore: use_key_in_widget_constructors
  const EditChildPage(this.child);

  @override
  State<EditChildPage> createState() => _EditChildPage();
}

class _EditChildPage extends State<EditChildPage> {
  var selectedValue = "未選択";

  final relationship = <String>[
    "未選択",
    "長男",
    "長女",
    "次男",
    "次女",
    "三男",
    "三女",
    "その他"
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AddUserModel>(
      create: (_) => AddUserModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ユーザー更新'),
          backgroundColor: Colors.black87,
        ),
        body: Center(
          child: Consumer<AddUserModel>(builder: (context, model, child) {
            return Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                children: [
                  GestureDetector(
                    child: SizedBox(
                      width: 200,
                      height: 200,
                      child: model.imageFileUpdate != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: Image.file(
                                (model.imageFileUpdate!),
                                width: 200,
                                height: 200,
                                fit: BoxFit.fill,
                              ))
                          : Container(
                              decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "images/upper_body-1.jpg"))),
                            ),
                    ),
                    onTap: () async {
                      await model.pickImageUpdate();
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  TextField(
                    maxLength: 15,
                    decoration: const InputDecoration(
                      hintText: '名前',
                    ),
                    onChanged: (text) {
                      model.editName = text;
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  DropdownButton<String>(
                    value: selectedValue,
                    items: relationship
                        .map((String list) =>
                            DropdownMenuItem(value: list, child: Text(list)))
                        .toList(),
                    onChanged: (String? value) {
                      setState(() {
                        selectedValue = value!;
                        model.editRelationship = selectedValue;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // 追加の処理
                      try {
                        await showLoadingDialog(context, timeoutSec: 10);
                        await model.editChild(
                            widget.child.id,
                            widget.child.name,
                            widget.child.imgUrl,
                            widget.child.relationship);
                        hideLoadingDialog();
                        // ignore: use_build_context_synchronously
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder:
                                (context, animation, secondaryAnimation) {
                              return Mypage(widget.child);
                            },
                            transitionsBuilder: (context, animation,
                                secondaryAnimation, child) {
                              const Offset begin = Offset(0.0, -0.5); // 下から上
                              // final Offset begin = Offset(0.0, -1.0); // 上から下
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
                      } catch (e) {
                        final snackBar = SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(e.toString()),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: const Text('更新する'),
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
