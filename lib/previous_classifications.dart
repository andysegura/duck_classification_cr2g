import 'package:flutter/material.dart';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


///The results screen calls the machine learning model, classifies, and displays the results.

class PreviousClassifications extends StatefulWidget {
  PreviousClassifications();

  @override
  PreviousClassificationsState createState() => PreviousClassificationsState();
}

class PreviousClassificationsState extends State<PreviousClassifications> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference predictionsDB = FirebaseFirestore.instance.collection('predictionsDB');

  // List<Map<String, String>> docIDs = [];
  var docIDs = <Map>[];

  void initState() {
    super.initState();
  }

  Future getInfoFromDB() async {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    await predictionsDB
        .where('uid', isEqualTo: uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["email"]);
        print(doc['image']);
        print(doc['mlPredicted']);
        print(doc['confidence']);
        print(doc['userPredicted']);
;
        docIDs.add(
            {
              'image': doc['image'],
              'mlPredicted' : doc['mlPredicted'],
              'confidence' : doc['confidence'],
              'userPredicted': doc['userPredicted'],
              'email': doc['email'],
              'uid': doc['uid'],
             // 'date/time': doc['date/time']
            }
        );
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
                          return ListTile(
                            title: Text(docIDs[index]['confidence']),
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

