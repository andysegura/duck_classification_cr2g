import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:animal_classification/previous_result.dart';
import 'package:animal_classification/nav_bar.dart';

///Previous classifications lists all previous classifications
///the user chose to save.

class PreviousBodyClassifications extends StatefulWidget {
  PreviousBodyClassifications();

  @override
  PreviousBodyClassificationsState createState() => PreviousBodyClassificationsState();
}

class PreviousBodyClassificationsState extends State<PreviousBodyClassifications> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference predictionsDB = FirebaseFirestore.instance.collection('predictionsDB');
  var docIDs = <Map>[]; //stores all previous results that will be shown on feed
  var img;

  Widget buildImageCard(int index) =>
      Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Container(
          margin: EdgeInsets.all(8),
          child: ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: GestureDetector(onTap: () async {
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
                child: Image(
                    image: Image
                        .memory(base64Decode(docIDs[index]['image']))
                        .image,
                    fit: BoxFit.cover
                ),
              )
          ),
        ),

      );

  Future getInfoFromDB() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    await predictionsDB
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['showOnFeed']) {
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
        backgroundColor: Colors.black,
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
        body: Center(
            child: FutureBuilder(
                future: getInfoFromDB(),
                builder: (context, snapshot) {
                  return GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 5,
                        crossAxisSpacing: 5,
                      ),
                      itemCount: docIDs.length,
                      itemBuilder: (context, index) => buildImageCard(index));
                }
            )
        )
    );
  }
}