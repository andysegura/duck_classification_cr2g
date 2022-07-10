import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

///The result screen displays the ML results.
///tflite model is ran in home.dart and sent to this page

class ResultsScreen extends StatefulWidget {
  File _image;
  String duckName;
  String confidence;
  ResultsScreen(this._image, this.duckName, this.confidence);
  @override
  ResultsScreenState createState() => ResultsScreenState(_image, duckName, confidence);
}

class ResultsScreenState extends State<ResultsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference predictionsDB = FirebaseFirestore.instance.collection('predictionsDB');
  File _image;
  String confidence;
  String? userPredicted;
  var duckName;

  ResultsScreenState(this._image, this.duckName, this.confidence);

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
      value: item,
      child: Text(
          item,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
            backgroundColor: Colors.white,
            color: Colors.black,
          )
      )
  );


  //sends result to firestore server
  Future sendClassification() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    final email = user?.email;
    final time = DateTime.now();

    predictionsDB.add({
      'mlPredicted': duckName,
      'confidence': confidence,
      'userPredicted': userPredicted,
      'image': base64Encode(_image.readAsBytesSync()),
      'date': '${time.month.toString()}/${time.day.toString()}/${time.year.toString()} ${time.hour.toString()}:${time.minute.toString()}',
      'uid' : uid,
      'email': email,
      'showOnFeed': true,
    }
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final predictionOptions = ['Unknown',
      'Diazi (Mexican Duck)',
      'Platyrhynchos (Mallard Duck)',
      'Other'];
    var duck;
    if (duckName == '0') {
      duck = 'Diazi (Mexican Duck)';
    }
    else {
      duck = 'Platyrhynchos (Mallard Duck)';
    }
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Machine Learning Results',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 0.8),
            )
        ),
        body: Container(
            color: Colors.black.withOpacity(0.9),
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Color(0xFF2A363B),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                    children:
                      [Text(duck,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        confidence + "% confident",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(child: Image.file(_image)),
                      SizedBox(height: 10),
                      Text(
                          'Your Prediction:',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                          )
                      ),
                      SizedBox(height: 5),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.black, width: 2),
                          color: Colors.white,
                        ),
                        child: DropdownButton<String>(
                            value: userPredicted,
                            items: predictionOptions.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() => this.userPredicted = value)
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: sendClassification,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(
                              child: Text(
                                "Save Result",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: () {Navigator.pop(context);},
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(
                              child: Text(
                                "Discard Result",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ]
                )
            )
        )
    );
  }
}