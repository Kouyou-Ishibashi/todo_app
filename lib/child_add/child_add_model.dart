import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddUserModel extends ChangeNotifier {
  //チルドレン登録用変数
  late String? id;
  late String? name;
  File? imageFile;
  final int possessionPoints = 0;
  late bool isLoading = false;
  late String imgUrl = '';
  late String relationship = "未選択";

  final picker = ImagePicker();

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  // ignore: non_constant_identifier_names
  Future AddUser() async {
    if (name == null || name!.isEmpty) {
      throw '名前が入力されていません';
    }

    if (relationship == "未選択") {
      throw '族柄が選択されていません';
    }

    final doc = FirebaseFirestore.instance.collection('children').doc();
    final String accountId = FirebaseAuth.instance.currentUser!.uid.toString();

    // 画像が選択されている場合、storageにアップロードする
    if (imageFile != null) {
      final task = await FirebaseStorage.instance
          .ref('todos/${doc.id}')
          .putFile(imageFile!);
      imgUrl = await task.ref.getDownloadURL();
      notifyListeners();
    }
    // firestoreに追加
    await doc.set({
      'accountId': accountId,
      'name': name,
      'imgUrl': imgUrl,
      'possessionPoints': possessionPoints,
      'relationship': relationship,
    });
  }

  Future pickImage() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      notifyListeners();
    }
  }

  // 子供の情報更新用変数
  late String editName = '石橋';
  late String editImgUrl = '';
  late String editRelationship = '';
  File? imageFileUpdate;

  Future pickImageUpdate() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

    if (pickedFile != null) {
      imageFileUpdate = File(pickedFile.path);
      notifyListeners();
    }
  }

  Future editChild(
      String id, String name, String imgUrl, String relationship) async {
    editName = name;
    editRelationship = relationship;

    if (name.isEmpty) {
      throw '名前が入力されていません';
    }

    final doc = FirebaseFirestore.instance.collection('children').doc();

    // 画像が選択されている場合、storageにアップロードする
    if (editImgUrl != '') {
      final task = await FirebaseStorage.instance
          .ref('todos/${doc.id}')
          .putFile(imageFileUpdate!);
      editImgUrl = await task.ref.getDownloadURL();
      notifyListeners();
    }
    // firestoreに追加
    await FirebaseFirestore.instance.collection('children').doc(id).update({
      'name': editName,
      'imgUrl': imageFileUpdate,
      'relationship': editRelationship,
    });
  }
}
