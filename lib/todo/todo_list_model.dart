import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/todo/todo.dart';
import '../children/child.dart';

class TodoListModel extends ChangeNotifier {
  final Child children;

  // 変数設定
  late String toChildrenId;
  late String toAccountId;
  late String toName;
  late String toImgUrl;
  late int toPossessionPoints;

  // 選択されたチルドレン情報取得
  TodoListModel(this.children) {
    toChildrenId = children.id;
    toAccountId = children.accountId;
    toName = children.name;
    toImgUrl = children.imgUrl;
    toPossessionPoints = children.possessionPoints;
  }

  // システム時間(yyyy-mm-dd hh:mm:ss)を文字列で取得
  late DateTime now = DateTime.now();
  final DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');
  late String createDate = format.format(now);

  //対象ユーザーIDのTodoデータ取得
  List<Todo>? todos;

  void fetchTodoList() {
    //変数定義
    // todos用変数
    late String todoId;
    late String childrenId;
    late String title;
    late int point;
    late String createDate;

    //対象データをtodosに格納
    FirebaseFirestore.instance
        .collection('todos')
        .where('childrenId', isEqualTo: toChildrenId)
        .orderBy('createDate')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      final List<Todo> todos = snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        todoId = document.id;
        childrenId = data['childrenId'];
        title = data['title'];
        point = data['point'];
        createDate = data['createDate'];
        return Todo(
          todoId,
          childrenId,
          title,
          point,
          createDate,
        );
      }).toList();
      this.todos = todos;
      notifyListeners();
    });
  }

  // 削除処理
  Future delete(Todo todo) async {
    await FirebaseFirestore.instance
        .collection("todos")
        .doc(todo.todoId)
        .delete();
    notifyListeners();
  }

  //Todo実施完了した場合、所持ポイントにTodoポイント追加した値に更新、Todoテーブルから削除、履歴テーブルに登録
  Future update(Todo todo) async {
    await FirebaseFirestore.instance
        .collection("children")
        .doc(toChildrenId)
        .update({
      'possessionPoints': toPossessionPoints + todo.point,
    });

    // Todo実施履歴登録処理
    await FirebaseFirestore.instance.collection("histories").add({
      'point': todo.point.toString(),
      'title': todo.title,
      'childrenId': toChildrenId,
      'dateTime': createDate,
      'useJudgeFlg': '0',
    });

    // Todo削除処理
    await FirebaseFirestore.instance
        .collection("todos")
        .doc(todo.todoId)
        .delete();
    notifyListeners();
  }

  /* ログアウト用 */
  // ログアウト用変数定義
  bool isLoading = false;

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // Todo作成用変数定義
  late String title;
  late int point = 0;

  // Todo作成処理
  Future inputTodo() async {
    if (title == "") {
      throw 'タイトルが入力されていません';
    }

    // ignore: unrelated_type_equality_checks
    if (point == "") {
      throw 'ポイントが入力されていません';
    }

    await FirebaseFirestore.instance.collection('todos').add({
      'childrenId': toChildrenId,
      'title': title,
      'point': point,
      'createDate': createDate,
    });

    notifyListeners();
  }

  // ignore: prefer_typing_uninitialized_variables
  late int possessionPoints = 0;
  void fetchPoint() async {
    final docs = await FirebaseFirestore.instance
        .collection('children')
        .doc(toChildrenId)
        .get();
    possessionPoints = docs.data()!['possessionPoints'];
    notifyListeners();
  }
}
