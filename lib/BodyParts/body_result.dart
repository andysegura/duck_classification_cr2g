import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animal_classification/nav_bar.dart';
import 'dart:io';

///The result screen displays the ML results.
///tflite model is ran in BodyParts/confirm_images.dart and sent to this page

class BodyResultsScreen extends StatefulWidget {
  Map _results;
  BodyResultsScreen(this._results);
  @override
  BodyResultsScreenState createState() => BodyResultsScreenState(_results);
}

class BodyResultsScreenState extends State<BodyResultsScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference bodyPredictionsDB = FirebaseFirestore.instance.collection('bodyPredictionsDB');
  Map _results;
  var duckName;
  String? userPredicted;

  BodyResultsScreenState(this._results);

  // dropdown menu so user can choose their own prediction
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
    print('----*****___---------______________------D');
    print(_results.toString());


    bodyPredictionsDB.add(
        {
      'date': '${time.month.toString()}/${time.day.toString()}/${time.year.toString()} ${time.hour.toString()}:${time.minute.toString()}',
      'uid' : uid,
      'email': email,
      'showOnFeed': true,

      'head_dorsal_image': base64Encode(_results['head_dorsal'][0].readAsBytesSync()),
      'head_dorsal_label': _results['head_dorsal'][1],
      'head_dorsal_confidence': _results['head_dorsal'][2],
      //'head_side_image': base64Encode(File(_results['head_side'][0].path).readAsBytesSync()),
      'head_side_label': _results['head_side'][1],
      'head_side_confidence': _results['head_side'][2],
      //'head_ventral_image': base64Encode(File(_results['head_ventral'][0].path).readAsBytesSync()),
      'head_ventral_label': _results['head_ventral'][1],
      'head_ventral_confidence': _results['head_ventral'][2],
      //'body_dorsal_image': base64Encode(File(_results['body_dorsal'][0].path).readAsBytesSync()),
      'body_dorsal_label': _results['body_dorsal'][1],
      'body_dorsal_confidence': _results['body_dorsal'][2],
      //'body_ventral_image': base64Encode(File(_results['body_ventral'][0].path).readAsBytesSync()),
      'body_ventral_label': _results['body_ventral'][1],
      'body_ventral_confidence': _results['body_ventral'][2],
      //'wing_dorsal_image': base64Encode(File(_results['wing_dorsal'][0].path).readAsBytesSync()),
      'wing_dorsal_label': _results['wing_dorsal'][1],
      'wing_dorsal_confidence': _results['wing_dorsal'][2],
      //'wing_ventral_image': base64Encode(File(_results['wing_ventral'][0].path).readAsBytesSync()),
      'wing_ventral_label': _results['wing_ventral'][1],
      'wing_ventral_confidence': _results['wing_ventral'][2],
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    String? userPredicted;
    final predictionOptions = ['Unknown',
      'Diazi (Mexican Duck)',
      'Platyrhynchos (Mallard Duck)',
      'Other'];
    var duck = 'diazi';
    return Scaffold(
        drawer: NavBar(),
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
                    [
                      Text(duck,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "% confident",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Expanded(child: Image.file(_results['head_dorsal'][0])),
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