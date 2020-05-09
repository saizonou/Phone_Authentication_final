import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:phone_authentication/ui/Home.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:phone_authentication/data/Constante.dart';
import 'package:phone_authentication/widget/ButtonWidget.dart';

class PhoneAuthentication extends StatefulWidget {
  @override
  PhoneAuthenticationState createState() => PhoneAuthenticationState();
}

class PhoneAuthenticationState extends State<PhoneAuthentication> {
  TextEditingController textEditingController = TextEditingController();

  StreamController<ErrorAnimationType> errorController;

  var onTapRecognizer;
  bool hasError = false;
  String currentText = "";
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  var phoneController = TextEditingController();
  var buttonPaddingTop, buttonPaddingBottom;
  var isCodeSent = false;
  var phoneNumber;
  FirebaseAuth _auth;
  String verificationId;

  @override
  void initState() {
    onTapRecognizer = TapGestureRecognizer()
      ..onTap = () {
        print("Resend code");
      };
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
  }

  @override
  void dispose() {
    errorController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mainMargin = MediaQuery.of(context).size.width * 0.06;
    buttonPaddingTop = MediaQuery.of(context).size.height * 0.05;
    buttonPaddingBottom = MediaQuery.of(context).size.height * 0.02;

    return Scaffold(
      appBar: AppBar(
        title: Text('Authentification'),
      ),
      backgroundColor: Color(KBackgroundColor),
      key: scaffoldKey,
      body: GestureDetector(
        onTap: () {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus) {
            currentFocus.unfocus();
          }
        },
        child: Container(
          margin: EdgeInsets.only(left: mainMargin, right: mainMargin, top: 20),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: isCodeSent ? phoneVerification() : getPhone(),
        ),
      ),
    );
  }

  //The widget to get the phone number
  Widget getPhone() => ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Image.asset(
              "images/firebase.png",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Text(
              "A verification code will be sent",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                top: buttonPaddingTop, bottom: buttonPaddingBottom),
            child: Container(
              child: TextFormField(
                controller: phoneController,
                maxLength: 10,
                keyboardType: TextInputType.number,
                minLines: 1,
                maxLines: 1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  labelText: 'Entrer votre numéro',
                  labelStyle: TextStyle(fontSize: 12),
                  prefixIcon: Icon(
                    Icons.phone,
                  ),
                  prefixText: '+233 ',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Champs obligatoire';
                  }
                  return null;
                },
              ),
            ),
          ),
          ButtonWidget(
            text: "Validate",
            function: loginUser,
          ),
        ],
      );

  //The widget fo verify the code
  Widget phoneVerification() => ListView(
        children: <Widget>[
          SizedBox(height: 30),
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Image.asset(
              "images/firebase.png",
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Phone verification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
            child: RichText(
              text: TextSpan(
                  text: "Enter the code sent to : ",
                  children: [
                    TextSpan(
                      text: phoneNumber,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ],
                  style: TextStyle(color: Colors.black54, fontSize: 15)),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
            child: PinCodeTextField(
              length: 6,
              obsecureText: false,
              textInputType: TextInputType.number,
              animationType: AnimationType.fade,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(5),
                fieldHeight: 50,
                fieldWidth: 40,
                inactiveColor: Colors.blueGrey,
                activeColor: Color(KPrimaryColor),
              ),
              animationDuration: Duration(milliseconds: 300),
              backgroundColor: Color(KBackgroundColor),
              enableActiveFill: false,
              errorAnimationController: errorController,
              controller: textEditingController,
              onCompleted: (v) {
                validateCode(v);
              },
              onChanged: (value) {
//                print(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                print("Allowing to paste $text");
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              hasError ? "*Fill all the fields" : "",
              style: TextStyle(color: Colors.red.shade300, fontSize: 15),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                text: "Didin't receive code? ",
                style: TextStyle(color: Colors.black54, fontSize: 15),
                children: [
                  TextSpan(
                    text: "RESEND",
                    recognizer: onTapRecognizer,
                    style: TextStyle(
                        color: Color(KPrimaryColor),
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  )
                ]),
          ),
          SizedBox(
            height: 14,
          ),
          ButtonWidget(
            text: "Verify",
            function: validateCode,
          ),
          SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("Clear code"),
                onPressed: () {
                  textEditingController.clear();
                },
              ),
            ],
          )
        ],
      );

  //Function to be triggered when the code is sent
  codeSent() {
    setState(() {
      //We change the state of the isCodeSent. It will display the phoneVerification widget
      phoneNumber = '+233${phoneController.text.trim()}';
      isCodeSent = true;
    });
  }

  //Function to be triggered to validate de code
  validateCode(String code) {
    // conditions for validating
    if (currentText.length != 6) {
      errorController
          .add(ErrorAnimationType.shake); // Triggering error shake animation
      setState(() {
        hasError = true;
      });
    } else {
      setState(() {
        hasError = false;
//        scaffoldKey.currentState.showSnackBar(SnackBar(
//          content: Text("Aye!!"),
//          duration: Duration(seconds: 2),
//        ));
        verifyCode(code);
      });
    }
  }

  Future<bool> loginUser() async {
    _auth = FirebaseAuth.instance;

    _auth.verifyPhoneNumber(
        phoneNumber: '+233${phoneController.text.trim()}',
        timeout: Duration(seconds: 30),
        verificationCompleted: (AuthCredential credential) async {
          AuthResult result = await _auth.signInWithCredential(credential);

          FirebaseUser user = result.user;

          if (user != null) {
//            SharedPreferences prefs = await SharedPreferences.getInstance();
//            await prefs.setString('uid', user.uid);
//            await prefs.setString('phone', user.phoneNumber);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyHomePage(),
              ),
            );
          } else {
            print("Error");
          }
          //This callback would gets called when verification is done
        },
        verificationFailed: (AuthException exception) {
          print(exception.message);
        },
        codeSent: (String verificationId, [int forceResendingToken]) {
          setState(() {
            isCodeSent = true;
            print(verificationId);
            this.verificationId = verificationId;
          });
        },
        codeAutoRetrievalTimeout: null);
  }

  void verifyCode(String code) async {
    AuthCredential credential = PhoneAuthProvider.getCredential(
        verificationId: verificationId, smsCode: code);

    AuthResult result = await _auth.signInWithCredential(credential);

    FirebaseUser user = result.user;
    if (user != null) {
//      SharedPreferences prefs = await SharedPreferences.getInstance();
//      await prefs.setString('uid', user.uid);
//      await prefs.setString('phone', user.phoneNumber);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MyHomePage(),
        ),
      );
    } else {
      print("Error");
    }
  }
}
