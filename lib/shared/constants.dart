import 'package:flutter/material.dart';

//remember to use .copyWith() to pass properties to const here

const textInputDecoration = InputDecoration(
    errorStyle: TextStyle(fontSize: 14.0),
    fillColor: Colors.white70,
    filled: true,
    focusColor: Colors.white70,
    hintStyle: TextStyle(fontSize: 18.0, color: Colors.black),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        )),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        )),
    focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.red, width: 2.0),
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        )),
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.black, width: 2.0),
        borderRadius: BorderRadius.all(Radius.circular(20.0))));
