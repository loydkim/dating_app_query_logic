import 'dart:core';

import 'package:datingalgorithm/controller.dart';
import 'package:flutter/material.dart';

import 'data.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with Controller{

  _updateLoadingStatus(bool value) => setState(() => isLoading = value);
  _updateUserData(UserData userData) => setState(() => currentUserData = userData);

  @override
  void initState() {
    updateLoadingStatus = _updateLoadingStatus;
    updateUserData = _updateUserData;
    currentContext = context;
    refreshUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dating Algorithm'),
      ),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _userDataActionButton(Colors.black,Colors.white,'Add User',addUserData),
                      _userDataActionButton(Colors.white,Colors.black,'Refresh',refreshUserData),
                      Text('Count: ${userDataList.length}',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 18),),
                    ],
                  ),
                  Divider(height: 6,color: Colors.black,),
                  Text('Search Option',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text('Gender',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        Row(
                          children: <Widget>[
                            _genderCheckBoxWithText(0,"Man"),
                            _genderCheckBoxWithText(1,"Woman"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text('Age',style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                        _ageRange(true),
                        Text('~',style: TextStyle(fontSize: 20),),
                        _ageRange(false),
                      ],
                    ),
                  ),
                  Divider(height: 6,color: Colors.black,),
                  currentUserData != null ? Column(
                    children: <Widget>[
                      Text('Select User',style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                      returnUserIcon(currentUserData.icon,currentUserData.color),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Name: ${currentUserData.name}, Age: ${currentUserData.age}, Gender: ${currentUserData.gender}',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          _bottomIconsButtons(Icons.report,40,Colors.red[900],blockUser),
                          _bottomIconsButtons(Icons.sentiment_dissatisfied,80,Colors.redAccent,disLikeUser),
                          _bottomIconsButtons(Icons.sentiment_satisfied,80,Colors.green[800],likeUser),
                          _bottomIconsButtons(Icons.settings_backup_restore,40,Colors.blue[800],clearBlockList),
                        ],
                      )
                    ],
                  ) : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('There is no data',style: TextStyle(fontSize: 26,fontWeight: FontWeight.bold),),
                  ),
                ],
              ),
            ),
          ),
          isLoading ? Positioned(
            child: loadingCircle(),
          ) : Container()
        ],
      ),
    );
  }

  Widget _ageRange(bool isMinimum){
    return Row(
      children: <Widget>[
        GestureDetector(
            onTap: (){
              int newMinimum = int.parse(isMinimum ? minimum : maximum);
              setState(() {
                isMinimum ? minimum = '${newMinimum-1 < 18 ? 18 : newMinimum-1}' :
                maximum = '${newMinimum-1 < 18 ? 18 : newMinimum-1}';
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right:8.0,left:8.0),
              child: Icon(Icons.remove_circle,size: 26,),
            )
        ),
        Text(isMinimum ? minimum : maximum,style: TextStyle(fontSize: 20),),
        GestureDetector(
            onTap: (){
              int newMinimum = int.parse(isMinimum ? minimum : maximum);
              setState(() {
                isMinimum ? minimum = '${newMinimum+1 > 50 ? 50:newMinimum+1}' :
                maximum = '${newMinimum+1 > 50 ? 50:newMinimum+1}';
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right:8.0,left:8.0),
              child: Icon(Icons.add_circle,size: 26),
            )
        ),
      ],
    );
  }

  Widget _bottomIconsButtons(IconData icon,double iconSize,Color iconColor,Function function){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () => function(),
          child: Icon(icon,size: iconSize,
            color: iconColor,)
      ),
    );
  }

  Widget _userDataActionButton(Color buttonColor,Color textColor,String buttonText, Function function){
    return Padding(
      padding: const EdgeInsets.only(right:8.0,left:8.0),
      child: RaisedButton(
        color: buttonColor,
        child: Text(buttonText,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: textColor),),
        onPressed: () => function(),
      ),
    );
  }

  Widget _genderCheckBoxWithText(int index,String genderType){
    return Row(
      children: <Widget>[
        Checkbox(
          value: genderList[index],
          onChanged: (bool newValue) {
            setState(() {
              if(index == 0 && !genderList[1] && newValue == false || index == 1 && !genderList[0] && newValue == false ) {
                showDialogWithText('You have to choice gender at least one of them');
              }else {
                genderList[index] = newValue;
              }
            });
          },
        ),

        GestureDetector(
          child: Text(genderType,style: TextStyle(fontSize: 18)),
          onTap: () {
            setState(() {
              if(index == 0 && !genderList[1] && !genderList[index] == false || index == 1 && !genderList[0] && !genderList[index] == false ) {
                showDialogWithText('You have to choice gender at least one of them');
              }else {
                genderList[index] = !genderList[index];
              }
            });
          },),
      ],
    );
  }


  Widget loadingCircle(){
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
      color: Colors.white.withOpacity(0.7),
    );
  }
}
