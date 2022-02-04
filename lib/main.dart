import 'package:flutter/material.dart';
import 'package:image_descriptors/app/background/background_view.dart';
import 'package:image_descriptors/app/home/home_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeView(),
      // home: BackgroundView(),
    );
  }
}
