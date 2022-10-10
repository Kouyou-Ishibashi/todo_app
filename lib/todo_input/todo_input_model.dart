import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class InputTodoModel extends ChangeNotifier {
  final _uid = FirebaseAuth.instance.currentUser?.uid.toString();

  late DateTime now = DateTime.now();
  final DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');
  late String createdate = format.format(now);

  String uid = 'id';
  late String title;
  late int point;

  Future inputTodo(accountid) async {
    if (title == "") {
      throw 'タイトルが入力されていません';
    }

    // ignore: unrelated_type_equality_checks
    if (point == "") {
      throw 'ポイントが入力されていません';
    }

    await FirebaseFirestore.instance.collection('todos').add({
      'accountid': accountid,
      'uid': _uid,
      'title': title,
      'point': point,
      'createdate': createdate,
    });
  }
}
