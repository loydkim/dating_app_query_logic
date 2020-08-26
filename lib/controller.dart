import 'dart:core';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datingalgorithm/data.dart';
import 'package:flutter/material.dart';

mixin Controller {
  bool isLoading = false;
  UserData currentUserData;
  int currentUserIndex = 0;
  List<UserData> userDataList = List<UserData>();
  List<String> userBlockList = List<String>();

  List<bool> genderList = [true,true];

  String minimum = '18';
  String maximum = '50';

  BuildContext currentContext;

  ValueChanged<bool> updateLoadingStatus;
  ValueChanged<UserData> updateUserData;

  void addUserData() async{
    try{
      updateLoadingStatus(true);
      String randomName = getRandomString(6);
      await Firestore.instance.collection('userData').document(randomName).setData({
        'name':randomName,
        'age': (18 + Random().nextInt(32)),
        'icon' : randomIconStringList[Random().nextInt(6)],
        'color' : randomColorStringList[Random().nextInt(6)],
        'gender' : randomGender[Random().nextInt(2)],
        'userNumber': Random().nextInt(100)
      });

      updateLoadingStatus(false);
      refreshUserData();

    } catch (err) {
      showDialogWithText('${err.message}');
    }
  }

  void refreshUserData() async{

    updateLoadingStatus(true);
    userDataList.clear();
    currentUserIndex= 0;

    final QuerySnapshot result = await Firestore.instance.
      collection('userData').
      where('gender',isEqualTo: (genderList[0] && genderList[1]) ? null : genderList[0] ? 'Man' : null).
      where('gender',isEqualTo: (genderList[0] && genderList[1]) ? null : genderList[1] ? 'Woman' : null).
      where('age',isGreaterThanOrEqualTo: int.parse(minimum)).
      where('age',isLessThanOrEqualTo: int.parse(maximum)).
      getDocuments();

    final List<DocumentSnapshot> documents = result.documents;
    if(documents.length > 0){
      for(var document in documents) {
        UserData userData = UserData(
          name:document['name'],
          age:document['age'],
          icon: document['icon'],
          color: document['color'],
          gender: document['gender'],
          userNumber: document['userNumber'],
        );

        if(!userBlockList.contains(userData.name)){
          userDataList.add(userData);
        }
      }
      updateUserData(userDataList[0]);
      updateLoadingStatus(false);
    }else {
      updateUserData(null);
      showDialogWithText('There is no user data');
      updateLoadingStatus(false);
    }
  }

  void disLikeUser(){
    _commonActionForChoiceUser();
  }

  void likeUser(){
    _commonActionForChoiceUser();
  }

  void _commonActionForChoiceUser(){
    currentUserIndex++;
    if(currentUserIndex < userDataList.length){
      updateUserData(userDataList[currentUserIndex]);
    }else {
      updateUserData(null);
      showDialogWithText('This is last user');
    }
  }

  void blockUser(){
    userBlockList.add(userDataList[currentUserIndex].name);
    refreshUserData();
  }

  void clearBlockList(){
    userBlockList.clear();
    refreshUserData();
  }

  void showDialogWithText(String textMessage) {
    showDialog(
        context: currentContext,
        builder: (context) {
          return AlertDialog(
            content: Text(textMessage),
          );
        }
    );
  }
}
