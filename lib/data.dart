import 'dart:core';
import 'dart:math';

import 'package:flutter/material.dart';

class UserData{
  String name;
  int age;
  String icon;
  String color;
  String gender;
  int userNumber;
  UserData({this.name,this.age,this.icon,this.color,this.gender,this.userNumber});
}

double userIconSize = 160.0;

Icon returnUserIcon(String iconName,String iconColor){
  Icon returnIcon;
  switch (iconName){
    case "airplanemode_active": {returnIcon = Icon(Icons.airplanemode_active,size: userIconSize,color:userColor(iconColor),); }break;
    case "monetization_on": {returnIcon = Icon(Icons.monetization_on,size: userIconSize,color:userColor(iconColor),); }break;
    case "router": {returnIcon = Icon(Icons.router,size: userIconSize,color:userColor(iconColor),); }break;
    case "panorama": {returnIcon = Icon(Icons.panorama,size: userIconSize,color:userColor(iconColor),); }break;
    case "directions_bike": {returnIcon = Icon(Icons.directions_bike,size: userIconSize,color:userColor(iconColor),); }break;
    case "directions_boat": {returnIcon = Icon(Icons.directions_boat,size: userIconSize,color:userColor(iconColor),); }break;
  }
  return returnIcon;
}

Color userColor(String colorName){
  Color returnColor;
  switch (colorName){
    case "black": {returnColor = Colors.black; }break;
    case "orange": {returnColor = Colors.orange; }break;
    case "green": {returnColor = Colors.green; }break;
    case "blue": {returnColor = Colors.blue; }break;
    case "pink": {returnColor = Colors.pink; }break;
    case "red": {returnColor = Colors.red; }break;
  }
  return returnColor;
}

// Random data lists

const List<String> randomGender= [
  "Man",
  "Woman",
];

const List<String> randomIconStringList= [
  "airplanemode_active",
  "monetization_on",
  "router",
  "panorama",
  "directions_bike",
  "directions_boat"
];

const List<String> randomColorStringList= [
  "black",
  "orange",
  "green",
  "blue",
  "pink",
  "red"
];

// Make random name sources

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
