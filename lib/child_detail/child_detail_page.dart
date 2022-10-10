// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:todo_app/user/user.dart';
// import 'package:todo_app/user_detail/user_detail_model.dart';
// import '../user_edit/user_edit_page.dart';

// class AccountDetailPage extends StatelessWidget {
//   final Child child;

//   const AccountDetailPage(this.child);

//   @override
//   Widget build(BuildContext context) {
//     return ChangeNotifierProvider<AccountDetailModel>(
//       create: (_) => AccountDetailModel(child),
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('詳細ページ'),
//           backgroundColor: Colors.black87,
//         ),
//         body: Consumer<AccountDetailModel>(builder: (context, model, child) {
//           return Column(
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               Container(
//                 margin: const EdgeInsets.only(top: 150),
//                 child: child.imgUrl != 'null'
//                     ? SizedBox(
//                         width: 200,
//                         height: 200,
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(200),
//                           child: Image.network(
//                             child.imgUrl,
//                             fit: BoxFit.fill,
//                           ),
//                         ),
//                       )
//                     : SizedBox(
//                         width: 200,
//                         height: 200,
//                         child: Container(
//                           decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                               image: DecorationImage(
//                                   image:
//                                       AssetImage("images/upper_body-1.jpg"))),
//                         ),
//                       ),
//               ),
//               Container(
//                 margin: const EdgeInsets.only(top: 50),
//                 child: Text(
//                   model.name,
//                   style: const TextStyle(
//                     fontSize: 30.0,
//                     fontFamily: 'Roboto',
//                     color: Colors.black,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 16,
//               ),
//               Center(
//                 child: Container(
//                   margin: const EdgeInsets.only(top: 50),
//                   child: ElevatedButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) =>
//                               EditAccountPage(child), // SecondPageは遷移先のクラス
//                         ),
//                       );
//                     },
//                     child: const Text('編集'),
//                   ),
//                 ),
//               ),
//             ],
//           );
//         }),
//       ),
//     );
//   }
// }
