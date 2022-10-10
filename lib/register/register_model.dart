import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class RegisterModel extends ChangeNotifier {
  //コントローラ変数定義
  final titleController = TextEditingController();
  final authorController = TextEditingController();

  //変数定義
  String? email;
  String? password;
  bool isLoading = false;

  //ログイン情報取得
  final FirebaseAuth auth = FirebaseAuth.instance;

  //ローディング
  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  //メールアドレス登録
  void setEmail(String email) {
    this.email = email;
    notifyListeners();
  }

  //パスワード登録
  void setPassword(String password) {
    this.password = password;
    notifyListeners();
  }

  //新規登録
  Future signUp() async {
    email = titleController.text;
    password = authorController.text;

    if (email != null && password != null) {
      // firebaseauthでユーザー作成
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email!, password: password!);
      final user = userCredential.user;

      if (user != null) {
        final accountId = user.uid;

        final doc = FirebaseFirestore.instance.collection('accounts').doc();
        await doc.set({
          'accountId': accountId,
          'email': email,
        });
      }
    }
  }
}
