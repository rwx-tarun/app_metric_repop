import 'package:flutter/material.dart';
import 'package:untitled/my_home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark),
      home: MyHomePage(title: 'APP USAGE METRIC'),
    );
  }
}
