import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user_login/shared/loading.dart';

class Home extends StatefulWidget {
  final Function getLoggedInStatus;

  Home({this.getLoggedInStatus});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Map userList, userList2, finalUserList = {"data": []};
  bool _isLoading = true;

  void getUserList() async {
    http.Response response =
        await http.get("https://reqres.in/api/users?page=1");
    http.Response response2 =
        await http.get("https://reqres.in/api/users?page=2");
    if (response.statusCode == 200 && response2.statusCode == 200) {
      userList = json.decode(response.body);
      userList2 = json.decode(response2.body);
      for (var map in userList['data']) {
        finalUserList["data"].add(map);
      }
      for (var map in userList2['data']) {
        finalUserList["data"].add(map);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    getUserList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text("Home"),
              actions: [
                FlatButton.icon(
                  icon: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    SharedPreferences sharedpref =
                        await SharedPreferences.getInstance();
                    setState(() {
                      sharedpref.setBool("loggedIn", false);
                      widget.getLoggedInStatus();
                    });
                  },
                  label: Text(
                    "Logout",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            body: Container(
              // padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView.builder(
                itemCount: finalUserList['data'].length,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                        "${finalUserList['data'][index]['first_name']} ${finalUserList['data'][index]['last_name']}"),
                    subtitle: Text(finalUserList['data'][index]['email']),
                    leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(finalUserList['data'][index]['avatar']),
                    ),
                  );
                },
              ),
            ),
          );
  }
}
