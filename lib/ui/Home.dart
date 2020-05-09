import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String phoneNumber = "";
  String userID = "";

  getUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      phoneNumber = user.phoneNumber;
      userID = user.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'Welcome home',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                "Phone : $phoneNumber",
                style: TextStyle(fontSize: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Text(
                'User ID : $userID',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
