import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:animal_classification/previous_result.dart';


///Previous classifications lists all previous classifications
///the user chose to save.

class PreviousClassifications extends StatefulWidget {
  PreviousClassifications();

  @override
  PreviousClassificationsState createState() => PreviousClassificationsState();
}

class PreviousClassificationsState extends State<PreviousClassifications> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference predictionsDB = FirebaseFirestore.instance.collection('predictionsDB');
  var docIDs = <Map>[];
  var img;

  Future getInfoFromDB() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    await predictionsDB
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['showOnFeed']) {
          print(doc['email']);
          print(doc['date']);
          String mlp;
          if (doc['mlPredicted'] == '0') {
            mlp = 'Diazi (Mexican Duck)';
          }
          else {
            mlp = 'Platyrhynchos (Mallard Duck)';
          }
          docIDs.add(
              {
                'image': doc['image'],
                'mlPredicted': mlp,
                'confidence': doc['confidence'],
                'userPredicted': doc['userPredicted'],
                'email': doc['email'],
                'uid': doc['uid'],
                'documentID': doc.id,
                'date': doc['date']
              }
          );
        }

      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //getInfoFromDB();
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.black12,
            title: Text(
              'Machine Learning Results',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 0.8),
            )
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: FutureBuilder(
                  future: getInfoFromDB(),
                  builder: (context, snapshot) {
                    return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return Container(
                            child: Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                      PreviousResult(
                                          docIDs[index]['image'],
                                          docIDs[index]['mlPredicted'],
                                          docIDs[index]['confidence'],
                                          docIDs[index]['userPredicted'],
                                          docIDs[index]['uid'],
                                          docIDs[index]['documentID'],
                                          docIDs[index]['date']
                                      )
                                    )
                                  );
                                },
                                  child: Expanded(
                                    child: Image(
                                        image: Image.memory(base64Decode(docIDs[index]['image'])).image),
                                  ),
                                ),
                                SizedBox(
                                    height: 10),
                                Text(
                                    "${docIDs[index]['mlPredicted']}  "
                                    "${docIDs[index]['confidence']}%",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold
                                  )
                                ),
                                Text(docIDs[index]['date'],
                                  style: TextStyle(
                                    fontSize: 20
                                  )
                                ),
                                SizedBox(height: 35),
                              ],
                            )
                          );
                        });
                  }
                )
              ),
            ]
          )
        )
    );
  }
}

