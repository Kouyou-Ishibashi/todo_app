import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/children/child.dart';

// アカウントごとの子供情報を一括管理
class ChildrenProviderModel extends ChangeNotifier {
  // 各情報を格納する変数
  List<Child>? children; //チルドレンリスト取得用変数
  // 処理日格納
  late DateTime now = DateTime.now();
  final DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');
  late String createDate = format.format(now);

  // 変数定義
  late String id;
  late String accountId;
  late String name;
  late String imgUrl;
  late int possessionPoints;
  late String relationship = '長男';
  final _uid = FirebaseAuth.instance.currentUser?.uid.toString();

  /* チルドレンリスト関連 */
  void fetchChildrenList() {
    // 特定のアカウントのチルドレン情報をデータベースから取得
    final Stream<QuerySnapshot> childrenStream = FirebaseFirestore.instance
        .collection('children')
        .where('accountId', isEqualTo: _uid)
        .snapshots();
    // チルドレンリスト格納
    childrenStream.listen((QuerySnapshot snapshot) {
      final List<Child> children =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        {
          id = document.id;
          accountId = data['accountId'];
          name = data['name'];
          imgUrl = data['imgUrl'];
          possessionPoints = data['possessionPoints'];
          relationship = data['relationship'];
        }
        return Child(
          id,
          accountId,
          name,
          imgUrl,
          possessionPoints,
          relationship,
        );
      }).toList();
      this.children = children;
      notifyListeners();
    });
  }

  //チルドレンのアカウント削除処理
  Future deleteUser(Child child) {
    return FirebaseFirestore.instance
        .collection("children")
        .doc(child.id)
        .delete();
  }

  //チルドレンのアカウントと紐づくTodo履歴削除
  Future deleteHistory(Child child) {
    return FirebaseFirestore.instance
        .collection("histories")
        .doc(child.id)
        .delete();
  }

  //チルドレンのアカウントと紐づくTodo削除
  Future deleteTodo(Child child) {
    return FirebaseFirestore.instance
        .collection("todos")
        .doc(child.id)
        .delete();
  }
}
