import 'package:flutter/material.dart';
import 'package:localstorage/localstorage.dart';
import 'package:provider/provider.dart';
import 'package:wallet/controllers/page_controller_app.dart';
import 'package:wallet/pages/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  LocalStorage localStorage = new LocalStorage("user");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(0xFFFAA42B),
        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(
              fontSize: 72.0, fontWeight: FontWeight.bold, color: Colors.white),
          title: TextStyle(
              fontSize: 36.0, fontStyle: FontStyle.italic, color: Colors.white),
          body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: ChangeNotifierProvider(
        create: (_) => PageControllerApp(),
        child: HomePage(),
      ),
    );
  }
}
