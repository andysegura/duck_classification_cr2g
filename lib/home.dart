import 'dart:io';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
// import 'package:animal_classification/Model/Classification.dart';
// import 'package:animal_classification/Model/ClassificationDBWorker.dart';
import 'package:animal_classification/Model/Utility.dart';
import 'package:animal_classification/previous_classifications.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  late File _image;
  late XFile _image2;
  late List _output;

  final picker = ImagePicker(); //allows us to pick image from gallery or camera
  var _duckNames = {
    '0': "Mexican (Diazi)",
    '1': "Fulvigula (Mottled)",
    '2': 'Platyrhynchos (Mallard)',
  };

  @override
  void initState() {
    //initS is the first function that is executed by default when this class is called
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    //dis function disposes and clears our memory
    super.dispose();
    Tflite.close();
  }

  classifyImage(File image) async {
    //this function runs the model on the image
    var output = await Tflite.runModelOnImage(
      path: image.path,
      numResults:
      5,
      //the amout of categories our neural network can predict (here no. of animals)
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      if (output != null) {
        _output = output;
      }

      _loading = false;
    });
  }

  loadModel() async {
    //this function loads our model
    await Tflite.loadModel(
      model: 'assets/duck_model.tflite',
      labels: 'assets/labels.txt',
    );
  }

  pickImage() async {
    //this function to grab the image from camera
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
    _image2 = image;
  }

  pickGalleryImage() async {
    //this function to grab the image from gallery
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    setState(() {
      _image = File(image.path);
    });
    classifyImage(_image);
    _image2 = image;
  }

  saveClassification() {
    Utility.saveImageToPreferences(
        Utility.base64String(_image.readAsBytesSync()));

    // ClassificationDBWorker dbHelper = ClassificationDBWorker();
    // String imgString = Utility.base64String(_image.readAsBytesSync());
    // int picClass = int.parse(_output[0]['label']);
    // Classification classification = Classification(0, imgString, picClass);
    // dbHelper.save(classification);
  }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          centerTitle: true,
          title: Text(
            'Show me your duck',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
              fontSize: 23,
            ),
          ),
        ),
        body: Container(
          color: Color.fromRGBO(68, 190, 255, 0.8),
          padding: EdgeInsets.symmetric(horizontal: 35, vertical: 50),
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color: Colors.indigo,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  child: Center(
                    child: _loading == true
                        ? null //show nothing if no picture selected
                        : Container(
                      child: Column(
                        children: [
                          Container(
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.5,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Divider(
                            height: 5,
                            thickness: 1,
                          ),
                          // ignore: unnecessary_null_comparison
                          _output != null
                              ? Text(
                            '${_duckNames[_output[0]['label']]} duck ${_output[0]['confidence']}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          )
                              : Container(),
                          _output != null
                              ? GestureDetector(
                            onTap: saveClassification,
                            child: Container(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width - 200,
                              alignment: Alignment.center,
                              padding:
                              EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 17),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Text(
                                'Save Classification',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          )
                              : Container(),
                          Divider(
                            height: 15,
                            thickness: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: pickImage,
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 200,
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Take A Photo',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: pickGalleryImage,
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 200,
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Pick From Gallery',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      GestureDetector(
                        onTap: () async {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PreviousClassifications()));
                        },
                        child: Container(
                          width: MediaQuery
                              .of(context)
                              .size
                              .width - 200,
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Previous Classifications',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
