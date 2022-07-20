import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:animal_classification/BodyParts/head_ventral.dart';

/// home page allows user to select picture from camera or gallery
/// home.dart then runs the image through the tflite
/// model and sends data to results_screen.dart.
/// User can also choose to view previous ML results

class HeadSideResult extends StatefulWidget {
  File _image;
  Map _results;
  HeadSideResult(this._image, this._results);

  @override
  _HeadSideResultState createState() => _HeadSideResultState(_image, _results);
}

class _HeadSideResultState extends State<HeadSideResult> {
  File _image;
  Map _results;

  _HeadSideResultState(this._image, this._results);

  //first function that is executed by default when this class is called
  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  //disposes and clears memory
  @override
  void dispose() {
    super.dispose();
    Tflite.close();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: 'assets/duck_model.tflite',
      labels: 'assets/labels.txt',
    );
  }
  //runs image through tflite model
  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults: 3,
      //the amount of categories our neural network can predict (here no. of animals)
      threshold: 0,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    print(output.toString());

    if (output != null) {
      _results['head_side'] = [
        _image,
        output[0]['label'],
        output[0]['confidence']
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text(
          'Head Side Result',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 23,
          ),
        ),
      ),
      body: Container(
        color: Colors.black.withOpacity(0.9),
        padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Head Side:',
                  style: TextStyle(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  )
              ),
              SizedBox(height:20),
              Image.file(_image),
              SizedBox(height: 30),
              Row(
                children: [
                  GestureDetector( //try again button
                    onTap: () {Navigator.pop(context);},
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text(
                          "Try Again",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 40),
                  GestureDetector(
                    onTap: () async {
                      await classifyImage(_image);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  HeadVentral(_results)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(15)
                      ),
                      child: Center(
                        child: Text(
                          "Accept",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}