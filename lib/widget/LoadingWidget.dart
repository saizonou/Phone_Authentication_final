import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => loading(context);

  /// Widget that display the activity indicator
  Widget loading(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            SizedBox(height: 40),
            Container(
              child: Platform.isAndroid
                  ? CircularProgressIndicator(
                      strokeWidth: 6,
                    )
                  : CupertinoActivityIndicator(radius: 20),
            )
          ],
        ),
      );
}
