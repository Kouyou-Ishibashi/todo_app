import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_app/register/register_page.dart';
import 'login/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal,
      body: Center(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 150),
              child: Text(
                '~子供のTodo管理アプリ~',
                style: GoogleFonts.pottaOne(
                  textStyle: Theme.of(context).textTheme.headlineSmall,
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            Text(
              'とぅどぅあぷり',
              style: GoogleFonts.pottaOne(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 30,
                color: Colors.black,
              ),
            ),
            Text(
              'ToDoApp',
              style: GoogleFonts.pottaOne(
                textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 50,
                color: Colors.black,
              ),
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 50),
              width: 300,
              height: 300,
              child: Image.asset('images/ToDo.png'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RegisterPage(), // SecondPageは遷移先のクラス
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      elevation: 16,
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.white //.withOpacity(0.5),
                      ),
                  child: const Text(
                    '新規登録',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'GenSenRounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            const LoginPage(), // SecondPageは遷移先のクラス
                      ),
                    );
                  },
                  style: TextButton.styleFrom(
                      primary: Colors.black,
                      elevation: 16,
                      minimumSize: const Size(100, 50),
                      backgroundColor: Colors.white //.withOpacity(0.5),
                      ),
                  child: const Text(
                    'ログイン',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontFamily: 'GenSenRounded',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
