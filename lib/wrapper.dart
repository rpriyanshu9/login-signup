import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_login/authentication/authenticate.dart';
import 'package:user_login/home/home.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool isLoggedIn = false;

  void getLoggedInStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = sharedPreferences.getBool("loggedIn");
    });
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    getLoggedInStatus();
  }

  @override
  Widget build(BuildContext context) {
    return isLoggedIn ? Home(getLoggedInStatus: getLoggedInStatus) : Authenticate(getLoggedInStatus: getLoggedInStatus);
  }
}
