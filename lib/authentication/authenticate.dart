import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:user_login/authentication/login.dart';
import 'package:user_login/authentication/sign_up.dart';

class Authenticate extends StatefulWidget {
  final Function getLoggedInStatus;

  Authenticate({this.getLoggedInStatus});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = false;

  void toggleView() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Hive.openBox('users'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return showSignIn
                ? LogIn(
                    toggleView: toggleView,
                    getLoggedInStatus: widget.getLoggedInStatus)
                : SignUp(
                    toggleView: toggleView,
                    getLoggedInStatus: widget.getLoggedInStatus);
          }
        } else {
          return Scaffold();
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    Hive.box('users').close();
  }
}
