// // ignore: avoid_web_libraries_in_flutter
// import 'dart:html';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import '../children/child.dart';

// class EditChildModel extends ChangeNotifier {
//   //名前の確認
//   late String? id;
//   late String? name;
//   File? imageFile;
//   final int possessionPoints = 0;
//   late bool isLoading = false;
//   late String imgUrl = '';
//   String relationship = "未選択";

//   final picker = ImagePicker();

//   void startLoading() {
//     isLoading = true;
//     notifyListeners();
//   }

//   void endLoading() {
//     isLoading = false;
//     notifyListeners();
//   }

//   // ignore: non_constant_identifier_names
//   Future AddUser() async {
//     if (name == null || name!.isEmpty) {
//       throw '名前が入力されていません';
//     }

//     if (relationship == "未選択") {
//       throw '族柄が選択されていません';
//     }

//     final doc = FirebaseFirestore.instance.collection('children').doc();
//     final String accountId = FirebaseAuth.instance.currentUser!.uid.toString();

//     // 画像が選択されている場合、storageにアップロードする
//     if (imageFile != null) {
//       final task = await FirebaseStorage.instance
//           .ref('todos/${doc.id}')
//           .putFile(imageFile!);
//       imgUrl = await task.ref.getDownloadURL();
//       notifyListeners();
//     }
//     // firestoreに追加
//     await doc.set({
//       'accountId': accountId,
//       'name': name,
//       'imgUrl': imgUrl,
//       'possessionPoints': possessionPoints,
//       'relationship': relationship,
//     });
//   }

//   Future pickImage() async {
//     final pickedFile =
//         await picker.pickImage(source: ImageSource.gallery, imageQuality: 40);

//     if (pickedFile != null) {
//       imageFile = File(pickedFile.path);
//       notifyListeners();
//     }
//   }
// }
