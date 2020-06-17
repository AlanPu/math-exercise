import 'package:flutter/material.dart';

import 'ui/home/home_page.dart';

class App extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: '计算练习',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(title: '计算练习'),
    );
  }
}
