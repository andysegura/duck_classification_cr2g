import 'package:flutter/material.dart';
import 'package:animal_classification/home.dart';
import 'package:animal_classification/nav_bar.dart';


class ConfirmImages extends StatefulWidget {
  Map _results;
  ConfirmImages(this._results);

  @override
  ConfirmImagesState createState() => ConfirmImagesState(_results);
}

class ConfirmImagesState extends State<ConfirmImages> {
  Map _results;
  var img;
  ConfirmImagesState(this._results);
  var body_parts = ['head_dorsal', 'head_side', 'head_ventral',
  'body_dorsal', 'body_ventral', 'wing_dorsal', 'wing_ventral'];


  Widget buildImageCard(int index) =>
      Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(0),
        ),
        child: Container(
          margin: EdgeInsets.all(8),
          child: Column(
            children:[ index != 7 ?
              Text(body_parts[index],
              style: TextStyle(
                fontSize: 25,
                )
              ) : SizedBox(height:10),
              ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: GestureDetector(onTap: () async {

                },
                  child: index != 7 ? Image(
                  image: Image.file(_results[body_parts[index]][0]).image,
                    width: 125,
                    height: 125,
                    fit: BoxFit.cover,
                  )
                      : Column(
                    children: [
                      SizedBox(height: 20),
                      GestureDetector( // take a photo button
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home())
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Continue',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      GestureDetector( // take a photo button
                        onTap: () async {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Home())
                          );
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width - 200,
                          alignment: Alignment.center,
                          padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            'Discard',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                      ),

                      ],
                  )
                )
            ),

            ]),
        ),

      );


  @override
  Widget build(BuildContext context) {
    //getInfoFromDB();
    return Scaffold(
        drawer: NavBar(),
        appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text(
              'Sequence results',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  letterSpacing: 0.8),
            )
        ),
        body: Center(
            child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 5,
                  crossAxisSpacing: 5,
                ),
                itemCount: _results.length + 1,
                itemBuilder: (context, index) => buildImageCard(index))


        )
    );

  }
}