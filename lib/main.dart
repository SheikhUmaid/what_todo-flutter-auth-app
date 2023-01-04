import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:what_todo/pages/home.dart';
import 'package:what_todo/pages/login.dart';

void main() async {
  await Hive.initFlutter();
  var box = await Hive.openBox('TokenBox');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final box = Hive.box('TokenBox');

  MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: box.get('token') == null ? '/login' : '/home',
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const MyHomePage(),
      },
    );
  }
}
