import 'package:animal_classification/BodyParts/body_start.dart';
import 'package:animal_classification/baseline_model.dart';
import 'package:animal_classification/previous_results_fork.dart';
import 'package:flutter/material.dart';
import 'package:animal_classification/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animal_classification/login_page.dart';

class NavBar extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //sign out function
    signOut() async {
      await auth.signOut();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
    return Drawer(
      child: ListView(
        children: [
          SizedBox(height: 5),
          Text('signed in as ${auth.currentUser?.email}',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Home()));
            }
          ),
          ListTile(
            leading: Icon(Icons.add_a_photo),
            title: Text('Baseline Model'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BaselineModel()));
              }
          ),
          ListTile(
            leading: Icon(Icons.add_a_photo),
            title: Text('Body Parts Model'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            BodyStart()));
              }
          ),
          ListTile(
            leading: Icon(Icons.dynamic_feed_sharp),
            title: Text('Previous Classifications'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            PreviousResultsFork()));
              }
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sign Out'),
            onTap: () {
              signOut();
            },
          )
        ],
      ),
    );
  }
}