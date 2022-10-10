import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../children/child.dart';

class PaymentModel extends ChangeNotifier {
  final Child children;

  // 変数設定
  late String toChildrenId;
  late String toAccountId;
  late String toName;
  late String toImgUrl;
  late int toPossessionPoints;

  // 選択されたチルドレン情報取得
  PaymentModel(this.children) {
    toChildrenId = children.id;
    toAccountId = children.accountId;
    toName = children.name;
    toImgUrl = children.imgUrl;
    toPossessionPoints = children.possessionPoints;
  }

  // テキストフィールドに入力された値を格納する変数
  late String title;
  late int point;

  // システム時間(yyyy-mm-dd hh:mm:ss)を文字列で取得
  late DateTime now = DateTime.now();
  final DateFormat format = DateFormat('yyyy-MM-dd hh:mm:ss');
  late String createDate = format.format(now);

  Future update(int point) async {
    // ポイントが入力されていない場合はエラー文出力
    // ignore: unrelated_type_equality_checks
    if (point == "") {
      throw 'ポイントが入力されていません';
    }

    // ポイントが所得ポイントを上回っている場合はエラー文出力
    if (point > toPossessionPoints) {
      throw 'ポイントが所得ポイントを上回っています';
    }

    // 所持ポイントから指定ポイントをひく
    await FirebaseFirestore.instance
        .collection('children')
        .doc(toChildrenId)
        .update({
      'possessionPoints': toPossessionPoints - point,
    });
  }

  Future input(
    int point,
    String title,
  ) async {
    await FirebaseFirestore.instance.collection("histories").add({
      'point': point.toString(),
      'title': title,
      'childrenId': toChildrenId,
      'dateTime': createDate,
      'useJudgeFlg': '1',
    });
  }
}
