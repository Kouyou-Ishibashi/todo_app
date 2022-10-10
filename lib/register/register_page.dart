import '../children/childrenlist_page.dart';
import 'register_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/register/register_model.dart';

// ignore: must_be_immutable
class RegisterPage extends StatelessWidget {
  bool isObscure = true;

  RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Consumer<RegisterModel>(builder: (context, model, child) {
            return Stack(
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      height: 350,
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(221, 57, 55, 55),
                            width: 2),
                        borderRadius: BorderRadius.circular(15),
                        color: const Color.fromARGB(221, 57, 55, 55),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            controller: model.titleController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20),
                              fillColor: Colors.grey,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              hintText: 'Email',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.email,
                              ),
                            ),
                            onChanged: (text) {
                              model.setEmail(text);
                            },
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          TextField(
                            obscureText: isObscure,
                            controller: model.authorController,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.all(20),
                              fillColor: Colors.grey,
                              filled: true,
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  width: 2,
                                  color: Colors.blueGrey,
                                ),
                              ),
                              hintText: 'パスワード',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: const Icon(
                                Icons.key,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(isObscure
                                    ? Icons.visibility_off
                                    : Icons.visibility),
                                onPressed: () {
                                  setState(() {
                                    isObscure = !isObscure;
                                  });
                                },
                              ),
                            ),
                            onChanged: (text) {
                              model.setPassword(text);
                            },
                          ),
                          const SizedBox(
                            height: 50,
                          ),
                          SizedBox(
                            width: double.infinity, //横幅
                            height: 50, //高さ
                            child: ElevatedButton(
                              onPressed: () async {
                                model.startLoading();

                                // 追加の処理
                                try {
                                  await model.signUp();
                                  // ignore: use_build_context_synchronously
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            const ChildrenList(),
                                      ));
                                } catch (e) {
                                  final snackBar = SnackBar(
                                    backgroundColor: Colors.red,
                                    content: Text(e.toString()),
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } finally {
                                  model.endLoading();
                                }
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.teal),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(50), //丸み具合
                                  ),
                                ),
                              ),
                              child: const Text('登録する'),
                            ),
                          ),
                        ],
                      ),
                    )),
                if (model.isLoading)
                  Container(
                    color: Colors.black54,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
