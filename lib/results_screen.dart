import 'package:animal_classification/Model/Classification.dart';
import 'package:animal_classification/Model/ClassificationDBWorker.dart';
//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'package:animal_classification/Model/Utility.dart';


///The results screen calls the machine learning model, classifies, and displays the results.

class ResultsScreen extends StatefulWidget {
  File _image;
  String duckName;
  String confidence;
  ResultsScreen(this._image, this.duckName, this.confidence);
  @override
  ResultsScreenState createState() => ResultsScreenState(_image, duckName, confidence);
}

class ResultsScreenState extends State<ResultsScreen> {
  File _image;
  String duckName;
  String confidence;
  // late List<dynamic> _output; //List<dynamic> _output;
  // final picker = ImagePicker();
  late ClassificationDBWorker dbHelper;
  ResultsScreenState(this._image, this.duckName, this.confidence);



  @override
  Widget build(BuildContext context) {
    ClassificationDBWorker dbHelper = ClassificationDBWorker();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black12,
        title: Text(
          'Duck Classifier',
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
          child: Column (
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                child: Center(
                  child: Container(
                      child: Column(
                        children: [
                          Container(
                              height: 250, width: 250,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: Image.file(
                                    _image,
                                    fit: BoxFit.fill,
                                  )
                              )
                          ),
                          Divider(
                            height: 25,
                            thickness: 1,
                          ),
                          ///Depending on the threshold we use, it's possible the predictions are empty. So we need to make sure that we can output something before accessing.
                          Text(
                              '$duckName Confidence: ${confidence * 100}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              )
                          ),
                          Divider(
                              height: 25,
                              thickness: 1
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF355C7D), // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: Text('Discard classification and return to main menu.'),
                          ),
                          Divider(
                              height: 25,
                              thickness: 1
                          ),
                          ///Checking that we have an actual prediction to save. If we do, we display a "save classification" button. If we don't, we don't display it.
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF355C7D), // background
                              onPrimary: Colors.white, // foreground
                            ),
                            onPressed: () async {
                              String imgString = Utility.base64String(_image.readAsBytesSync());
                              ///Making sure a prediction was actually made

                              int picClass = int.parse(duckName);
                              Classification classification = Classification(0, imgString, picClass);
                              dbHelper.save(classification);

                              Navigator.pop(context);
                            },
                            child: const Text('Save classification and return to main menu.')
                          )
                        ],
                      )
                  )
                )
              )
            ],
          )
        )
      )
    );
  }
}