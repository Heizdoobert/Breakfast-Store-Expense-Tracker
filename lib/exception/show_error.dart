import 'package:flutter/material.dart';
import 'package:get/get.dart';

Future<bool?> showError(String error, String stack) async
{
  return await Get.dialog(AlertDialog(
    title: const Text("Lỗi"),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text(error),
          Text(stack),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: const Text("Đóng"),
        onPressed: () {
          Get.back();
        },
      ),
    ],
  )
  );
}