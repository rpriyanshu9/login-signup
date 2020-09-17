import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_login/shared/constants.dart';
import 'package:user_login/shared/loading.dart';

class SignUp extends StatefulWidget {
  final Function toggleView, getLoggedInStatus;

  SignUp({this.toggleView, this.getLoggedInStatus});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {  Alignment childAlignment = Alignment.center;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController emailController;
  TextEditingController passwordController;
  Map jsonData;
  bool _isLoading = false;

  _signUpAPIreq(String email, String password) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String baseUrl = "https://reqres.in/api/register";
    http.Response response =
        await http.post(baseUrl, body: {"email": email, "password": password});
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      final usersBox = Hive.box('users');
      if (usersBox.get(jsonData['token'])!=null){
        setState(() {
          _isLoading = false;
        });
        showDialog(
            context: context,
            builder: (_) {
              return AlertDialog(
                title: Text("You already have an account"),
                titlePadding: EdgeInsets.all(10.0),
                content: Text("Log in to continue"),
                elevation: 20.0,
                actions: [
                  FlatButton(onPressed:()=> Navigator.pop(context), child: Text("OK"))
                ],
              );
            },
            barrierDismissible: true);
      }
      else{
        usersBox.put(jsonData['token'], jsonData['id']);
        setState(() {
          sharedPreferences.setBool("loggedIn", true);
          widget.getLoggedInStatus();
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Invalid Credentials"),
              titlePadding: EdgeInsets.all(10.0),
              content: Text("Try Again!"),
              elevation: 20.0,
              actions: [
                  FlatButton(onPressed:()=> Navigator.pop(context), child: Text("OK"))
                ],
            );
          },
          barrierDismissible: true);
    }
  }

  @override
  void dispose() {
    // ignore: todo
    // TODO: implement dispose
    super.dispose();
    _isLoading = false;
  }

  @override
  void initState() {
    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        setState(() {
        childAlignment = visible ? Alignment.topCenter : Alignment.center;
      });
      },
    );
    // ignore: todo
    // TODO: implement initState
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    emailController.addListener(() {
      setState(() {});
    });
    passwordController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: _isLoading
          ? Loading()
          : Scaffold(
              resizeToAvoidBottomPadding: false,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                title: Text('Sign Up'),
              ),
              body: AnimatedContainer(
                curve: Curves.easeOut,
                  duration: Duration(milliseconds: 400),
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(20),
                  alignment: childAlignment,
                child: SingleChildScrollView(
                                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          controller: emailController,
                          validator: emailValidator,
                          decoration: textInputDecoration.copyWith(hintText: "Email"),),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.black, fontSize: 18.0),
                          controller: passwordController,
                          validator: (a) {
                            if (a.isEmpty) {
                              return "Password cannot be empty";
                            } else {
                              return null;
                            }
                          },
                          obscureText: true,
                          decoration: textInputDecoration.copyWith(hintText: "Password"),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        RaisedButton(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Text(
                            "Register",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          // this is async as sign in results in using firebase utilities and that might take sometime
                          onPressed: () {
                            String em = emailController.text;
                            String ps = passwordController.text;
                            if (formKey.currentState.validate()) {
                              setState(() {
                                _isLoading = true;
                                _signUpAPIreq(em, ps);
                              });
                            }
                          },
                        ),
                        SizedBox(
                          height: 15.0,
                        ),
                        Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                            side: BorderSide(color: Colors.black),
                          ),
                          child: Text(
                            "Log In",
                            style:
                                TextStyle(color: Colors.black, fontSize: 18.0),
                          ),
                          // this is async as sign in results in using firebase utilities and that might take sometime
                          onPressed: () {
                            widget.toggleView();
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$';
    RegExp regex = new RegExp(pattern);
    if (value.isEmpty) return '*Required';
    if (!regex.hasMatch(value))
      return '*Enter a valid email';
    else
      return null;
  }
}
