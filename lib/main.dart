import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reading_messege_app/home_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SMS Listener',
      home: SmsListener(),
    );
  }
}
