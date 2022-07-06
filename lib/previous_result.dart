//
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// ///Previous Result shows the results of a single saved prediction.
//
// class PreviousResult extends StatefulWidget {
//   String _image;
//   String mlPredicted;
//   String confidence;
//   String userPredicted;
//   String uid;
//   String documentID;
//
//   PreviousResult(this._image, this.mlPredicted, this.confidence,
//       this.userPredicted, this.uid, this.documentID);
//
//   @override
//   PreviousResultState createState() => PreviousResultState(
//       _image, mlPredicted, confidence, userPredicted, uid, documentID);
// }
//
// class PreviousResultState extends State<PreviousResult> {
//   final FirebaseAuth auth = FirebaseAuth.instance;
//   //FirebaseFirestore firestore = FirebaseFirestore.instance;
//   CollectionReference predictionsDB = FirebaseFirestore.instance.collection('predictionsDB');
//   String _image;
//   String mlPredicted;
//   String confidence;
//   String userPredicted;
//   String uid;
//   String documentID;
//   String userPredictedDropdown = '';
//
//   PreviousResultState(this._image, this.mlPredicted, this.confidence,
//       this.userPredicted, this.uid, this.documentID);
//
//   DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
//       value: item,
//       child: Text(
//           item,
//           style: TextStyle(
//             fontSize: 17,
//             fontWeight: FontWeight.bold,
//             backgroundColor: Colors.white,
//             color: Colors.black,
//           )
//       )
//   );
//
//   Future changePrediction() async {
//     predictionsDB.doc(documentID).update({'userPredicted': 'test'});
//   }
//
//   Future deleteResult() async {
//     predictionsDB.doc(documentID).update({'shownInFeed': false});
//   }
//
//
//   Future sendRequest() async {
//     // final User? user = auth.currentUser;
//     // final uid = user?.uid;
//     // final email = user?.email;
//     // final time = DateTime.now();
//     //
//     // predictionsDB.add({
//     //   'mlPredicted': duckName,
//     //   'confidence': confidence,
//     //   'userPredicted': userPredicted,
//     //   'image': base64Encode(_image.readAsBytesSync()),
//     //   'date/time': '${time.month }/${time.day}/${time.year} ${time.hour}:${time.minute}',
//     //   'uid' : uid,
//     //   'email': email,
//     // }
//     //);
//
//     // final FirebaseStorage _storage =
//     //     FirebaseStorage.instance;
//     // final destination = 'duck_images/$_image.path';
//     // final fileName = _image.path;
//     // File file = File(fileName);
//     // try {
//     //   await _storage.ref(destination).putFile(file);
//     // } on FirebaseException catch(e) {
//     //   print(e);
//     // }
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     final predictionOptions = ['Unknown',
//       'Diazi (Mexican Duck)',
//       'Platyrhynchos (Mallard Duck)',
//       'Other'];
//     return Scaffold(
//         appBar: AppBar(
//             backgroundColor: Colors.black12,
//             title: Text(
//               'Previous Result',
//               style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 20,
//                   letterSpacing: 0.8),
//             )
//         ),
//         body: Container(
//             color: Colors.black.withOpacity(0.9),
//             padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//             child: Container(
//                 alignment: Alignment.center,
//                 padding: EdgeInsets.all(30),
//                 decoration: BoxDecoration(
//                   color: Color(0xFF2A363B),
//                   borderRadius: BorderRadius.circular(10),
//                 ),
//                 child: Column(
//                     children: [
//                       Text(
//                         mlPredicted,
//                         style: TextStyle(
//                           fontSize: 30,
//                           color: Colors.white,
//                       ),
//                     ),
//                       SizedBox(height: 10),
//                       Text(
//                         confidence + "% confident",
//                         style: TextStyle(
//                           fontSize: 25,
//                           color: Colors.white,
//                         ),
//                       ),
//                       SizedBox(height: 10),
//                       Image(image: Image.memory(base64Decode(_image)).image),
//                       SizedBox(height: 20),
//                       Text(
//                           'Change Prediction?',
//                           style: TextStyle(
//                             fontSize: 20,
//                             color: Colors.white,
//                           )
//                       ),
//                       SizedBox(height: 5),
//                       Container(
//                         decoration: BoxDecoration(
//                           border: Border.all(color: Colors.black, width: 2),
//                           color: Colors.white,
//                         ),
//
//
//                         child: DropdownButton<String>(
//                             value: userPredictedDropdown,
//                             items: predictionOptions.map(buildMenuItem).toList(),
//                             onChanged: (value) => setState(() => this.userPredictedDropdown = value!)
//                         ),
//                       ),
//                       SizedBox(height: 25),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(horizontal: 25.0),
//                         child: GestureDetector(
//                           onTap: changePrediction,
//                           decoration: BoxDecoration(
//                               color: Colors.lightBlue,
//                               borderRadius: BorderRadius.circular(15)
//                           ),
//                           child: Center(
//                             child: Text(
//                               "Change user prediction",
//                               style: TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 20,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//             ),
//             SizedBox(height: 25),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25.0),
//               child: GestureDetector(
//                 onTap: deleteResult,
//                 child: Container(
//                   padding: EdgeInsets.all(20),
//                   decoration: BoxDecoration(
//                       color: Colors.lightBlue,
//                       borderRadius: BorderRadius.circular(15)
//                   ),
//                   child: Center(
//                     child: Text(
//                       "Delete result",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 20,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             ]
//         )
//     )
//     )
//     );
//   }
// }                  child: Container(
//                             padding: EdgeInsets.all(20),
//
//



import 'dart:convert';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:path/path.dart' as Path;



///The results screen calls the machine learning model, classifies, and displays the results.

class PreviousResult extends StatefulWidget {
  String _image;
  String mlPredicted;
  String confidence;
  String userPredicted;
  String uid;
  String documentID;


  PreviousResult(this._image, this.mlPredicted, this.confidence,
      this.userPredicted, this.uid, this.documentID);

  @override
  PreviousResultState createState() => PreviousResultState(
      _image, mlPredicted, confidence, userPredicted, uid, documentID);
}

class PreviousResultState extends State<PreviousResult> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  CollectionReference predictionsDB = FirebaseFirestore.instance.collection('predictionsDB');
  String _image;
  String mlPredicted;
  String confidence;
  String userPredicted;
  String uid;
  String documentID;
  String? userPredictedDropdown;

  // late List<dynamic> _output; //List<dynamic> _output;
  // final picker = ImagePicker();
  PreviousResultState(this._image, this.mlPredicted, this.confidence,
      this.userPredicted, this.uid, this.documentID);

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

  Future changePrediction() async {
    predictionsDB.doc(documentID).update({'userPredicted': userPredictedDropdown});
  }

  Future deleteResultFromFeed() async {
    predictionsDB.doc(documentID).update({'showOnFeed': false});
    Navigator.pop(context);
  }


  Future sendRequest() async {
    // final User? user = auth.currentUser;
    // final uid = user?.uid;
    // final email = user?.email;
    // final time = DateTime.now();
    //
    // predictionsDB.add({
    //   'mlPredicted': duckName,
    //   'confidence': confidence,
    //   'userPredicted': userPredicted,
    //   'image': base64Encode(_image.readAsBytesSync()),
    //   'date/time': '${time.month }/${time.day}/${time.year} ${time.hour}:${time.minute}',
    //   'uid' : uid,
    //   'email': email,
    // }
    //);

    // final FirebaseStorage _storage =
    //     FirebaseStorage.instance;
    // final destination = 'duck_images/$_image.path';
    // final fileName = _image.path;
    // File file = File(fileName);
    // try {
    //   await _storage.ref(destination).putFile(file);
    // } on FirebaseException catch(e) {
    //   print(e);
    // }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {

    final predictionOptions = ['Unknown',
      'Diazi (Mexican Duck)',
      'Platyrhynchos (Mallard Duck)',
      'Other'];
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black12,
            title: Text(
              'Previous Result',
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
                    children: [
                      Text(
                        mlPredicted,
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        confidence + "% confident",
                        style: TextStyle(
                          fontSize: 25,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 10),
                      Image(image: Image.memory(base64Decode(_image)).image),
                      SizedBox(height: 20),
                      Text(
                          'Change Prediction?',
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
                            value: userPredictedDropdown,
                            items: predictionOptions.map(buildMenuItem).toList(),
                            onChanged: (value) => setState(() => this.userPredictedDropdown = value!)
                        ),
                      ),
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: GestureDetector(
                          onTap: changePrediction,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(
                              child: Text(
                                "Change user prediction",
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
                          onTap: deleteResultFromFeed,
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                                color: Colors.lightBlue,
                                borderRadius: BorderRadius.circular(15)
                            ),
                            child: Center(
                              child: Text(
                                "Delete result",
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
