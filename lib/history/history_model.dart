import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../children/child.dart';
import 'history.dart';

class HistoryListModel extends ChangeNotifier {
  final Child children;

  // 変数設定
  late String toChildrenId;
  late String toAccountId;
  late String toName;
  late String toImgUrl;
  late int toPossessionPoints;

  HistoryListModel(this.children) {
    toChildrenId = children.id;
    toAccountId = children.accountId;
    toName = children.name;
    toImgUrl = children.imgUrl;
    toPossessionPoints = children.possessionPoints;
  }

  List<History>? histories;

  void fetchHistoryList() {
    //変数定義
    late String childrenId;
    late String title;
    late String point;
    late String dateTime;
    late String useJudgeFlg;

    FirebaseFirestore.instance
        .collection('histories')
        .limit(10)
        .where("childrenId", isEqualTo: toChildrenId)
        .orderBy('dateTime', descending: true)
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      final List<History> histories =
          snapshot.docs.map((DocumentSnapshot document) {
        Map<String, dynamic> data = document.data() as Map<String, dynamic>;
        childrenId = data['childrenId'];
        title = data['title'];
        point = data['point'];
        dateTime = data['dateTime'];
        useJudgeFlg = data['useJudgeFlg'];
        return History(childrenId, title, point, dateTime, useJudgeFlg);
      }).toList();
      this.histories = histories;
      notifyListeners();
    });
  }
}
