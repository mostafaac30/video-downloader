import 'package:flutter/material.dart';
import 'package:receivesharing/ui/home/home_screen.dart';
import 'package:receivesharing/util/Injector.dart';

void main() async {
  await baseDio();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Youtube Downloader',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
