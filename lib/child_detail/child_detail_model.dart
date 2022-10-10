import 'package:flutter/material.dart';
import 'package:todo_app/children/child.dart';

class AccountDetailModel extends ChangeNotifier {
  late final Child child;

  String childrenId = 'none';
  String name = 'none';
  String imgUrl = 'none';
  AccountDetailModel(this.child) {
    name = child.name;
    imgUrl = child.imgUrl;
  }
}
