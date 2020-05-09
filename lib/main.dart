import 'package:flutter/material.dart';
import 'package:phone_authentication/data/Constante.dart';
import 'package:phone_authentication/ui/PhoneAuthentication.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Color(KPrimaryColor),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: PhoneAuthentication(),
    );
  }
}
