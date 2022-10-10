import 'dart:async';
import 'package:flutter/material.dart';

BuildContext? _loadingDialogContext;

Future<void> showLoadingDialog(BuildContext context,
    {int durationTime = 20, required int timeoutSec}) async {
  if (_loadingDialogContext != null) {
    return;
  }

  //awaitは付けない
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        _loadingDialogContext = context;
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints.expand(width: 50, height: 50),
            child: const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue)),
          ),
        );
      });
  await Future.delayed(Duration(milliseconds: durationTime));
  return;
}

Future<void> hideLoadingDialog() async {
  final context = _loadingDialogContext;
  if (context != null) {
    Navigator.of(context).pop();
    _loadingDialogContext = null;
  }
}
