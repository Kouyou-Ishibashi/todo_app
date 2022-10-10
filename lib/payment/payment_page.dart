import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:todo_app/payment/payment_model.dart';
import 'package:provider/provider.dart';

import '../children/child.dart';
import '../point/point_page.dart';

class PaymentPage extends StatefulWidget {
  final Child children;

  // ignore: use_key_in_widget_constructors
  const PaymentPage(this.children);

  @override
  // ignore: library_private_types_in_public_api
  _PaymentPage createState() => _PaymentPage();
}

class _PaymentPage extends State<PaymentPage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<PaymentModel>(
      create: (_) => PaymentModel(widget.children),
      child: Scaffold(
          appBar: AppBar(
            title: const Text('引き落とし'),
            backgroundColor: Colors.black87,
          ),
          body: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Text(
                  '取得ポイント ${widget.children.possessionPoints}P',
                  style: const TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Consumer<PaymentModel>(builder: (context, model, child) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        TextField(
                          maxLength: 15,
                          decoration: const InputDecoration(
                            hintText: '引き落とし理由',
                          ),
                          onChanged: (text) {
                            model.title = text;
                          },
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: const InputDecoration(
                            hintText: '引き落としポイント数',
                          ),
                          onChanged: (text) {
                            model.point = int.parse(text);
                          },
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // 追加の処理
                            try {
                              await model.update(model.point);
                              await model.input(
                                model.point,
                                model.title,
                              );
                              // ignore: use_build_context_synchronously
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      PointPage(widget.children),
                                ),
                              );
                            } catch (e) {
                              final snackBar = SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(e.toString()),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: const Text('引き落とす'),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ],
          )),
    );
  }
}
