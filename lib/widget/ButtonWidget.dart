import 'package:flutter/material.dart';
import 'package:phone_authentication/data/Constante.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final Function function;

  ButtonWidget({@required this.text, @required this.function});

  @override
  Widget build(BuildContext context) => button(text, context, function);

  Widget button(String text, BuildContext context, Function function) => Center(
        child: Container(
          width: MediaQuery.of(context).size.width * 0.6,
          height: MediaQuery.of(context).size.height * 0.07,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
              side: BorderSide(color: Color(KPrimaryColor)),
            ),
            onPressed: () {
              function();
            },
            color: Color(KPrimaryColor),
            textColor: Colors.white,
            child: Text(text, style: TextStyle(fontSize: 15)),
          ),
        ),
      );
}
