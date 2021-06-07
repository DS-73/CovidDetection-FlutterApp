import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

const _urlGithub = 'https://github.com/DS-73';
const _urlLinkedIN = 'https://www.linkedin.com/in/dhruv73/';

class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _loading = true;
  File _image;
  List _output;
  final picker = ImagePicker();

  @override
  void initState() { 
    super.initState();
    loadModel().then((value) {
      setState(() {
        // pass
      });
    });
  }

  classifyImage(File image) async {
    var output = await Tflite.runModelOnImage(path: image.path,
      numResults: 2,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    Tflite.close();
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite',
        labels: 'assets/labels.txt',
      );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  pickImage() async {
    var image = await picker.getImage(
      source: ImageSource.camera,
    );
    if(image == null)
      return null;
    
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  pickGalleryImage() async {
    var image = await picker.getImage(
      source: ImageSource.gallery,
    );
    if(image == null)
      return null;
    
    setState(() {
      _image = File(image.path);
    });

    classifyImage(_image);
  }

  void _launchURLLinkedIN() async =>
    await canLaunch(_urlLinkedIN) ? await launch(_urlLinkedIN) : throw 'Could not launch $_urlLinkedIN';
  
  void _launchURLGithub() async =>
    await canLaunch(_urlGithub) ? await launch(_urlGithub) : throw 'Could not launch $_urlGithub';

    @override
    Widget build(BuildContext context) => DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "AutoAI: Machine Learning",
            textScaleFactor: 1,
          ),
          titleSpacing: 0.0,
          centerTitle: true,
          toolbarHeight: 200.2,
          shape: RoundedRectangleBorder(borderRadius: 
            BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
          elevation: 20.00,
          //backgroundColor: Color(0xFFFFA000),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:[
                  Colors.amber,
                  Colors.red,
                ],
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            tabs: [
              Tab(
                icon: Icon(Icons.account_tree),
                text: 'How to Use?',
              ),
              Tab(
                icon: Icon(Icons.home),
                text: 'Home',
              ),
              Tab(
                icon: Icon(Icons.account_balance),
                text: 'About',
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildPage2('How to Page'),
            buildPage1('Home Page'),
            buildPage3('About Page'),
          ],
        ),
      ),
    );

    Widget buildPage1(String text) {
      return Scaffold(
          backgroundColor: Colors.white38,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60),
                Text('CNN', style: TextStyle(color: Color(0xFFEEDA28), fontSize: 18)),
                SizedBox(height: 6),
                Text("COVID Detection", style: TextStyle(color: Color(0xFFE99600), fontWeight: FontWeight.w500, fontSize: 28,)),
                SizedBox(height: 40),
                Center(child: _loading? Container(
                  width: 200,
                  child: Column(children: <Widget>[
                    Image.asset('assets/covid.png', cacheHeight: 200, cacheWidth: 200,),
                    SizedBox(height: 50),
                  ],
                  )
                  ) : Container(
                    child: Column(
                      children: <Widget>[
                        Container(
                          height: 250,
                          child: Image.file(_image),
                        ),
                        SizedBox(height: 20),
                        _output != null ? Text('${_output[0]}', style: TextStyle(color: Colors.black, fontSize: 25,),):Container(),
                      ],
                    ),
                  )
                ),
                Container(
                  child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(top: 1.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            '  ',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA),
                            )
                          ),
                          new Text(
                            '',
                            style: new TextStyle(
                              fontSize: 35.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA)
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    GestureDetector(
                      onTap: () => pickImage(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 210,
                        alignment: Alignment.center,
                        padding: 
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17, ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE99600),
                          borderRadius: BorderRadius.circular(6)  
                        ),
                        child: Text("Take a photo", style: TextStyle(color: Colors.white, fontSize: 20))
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => pickGalleryImage(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 210,
                        alignment: Alignment.center,
                        padding: 
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17, ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE99600),
                          borderRadius: BorderRadius.circular(6)  
                        ),
                        child: Text("Select from the storage", style: TextStyle(color: Colors.white, fontSize: 20))
                      ),
                    ),
                  ],
                  )
                ),
              ],
            )

          ),
        );
      }

    Widget buildPage2(String text) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60),
                Text("How To Use", style: TextStyle(color: Color(0xFFE99600), fontWeight: FontWeight.w500, fontSize: 28,)),
                SizedBox(height: 40),
                Center(
                  child: Column(children: <Widget>[
                    Image.asset('assets/howto.png', cacheHeight: 200, cacheWidth: 200,),
                    SizedBox(height: 50),
                  ],)
                  ),
                Container(
                  child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(top: 1.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            '  ',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA),
                            )
                          ),
                          new Text(
                            'Steps for Prediction - ',
                            style: new TextStyle(
                              fontSize: 35.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA)
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ),

                Container(
                  child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(top: 16.0),
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            '  ',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA),
                            )
                          ),
                        ],
                      ),
                    ),
                    new Text(
                      '1. Go to Home Tab.\n2. Select one option.\n    - Take a photo: Use camera to take photo of X-Ray.\n    - Select from storage: Use a saved image.\n\nYour Prediction result is ready.',
                      style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      )
                    ),
                    new Text(''),
                    new Text(''),
                    new Text(''),
                  ],
                ),
                ),
              
              ],
            )
          ),
        );
      }

    Widget buildPage3(String text) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 60),
                Text("About Section", style: TextStyle(color: Color(0xFFE99600), fontWeight: FontWeight.w500, fontSize: 28,)),
                SizedBox(height: 40),
                Center(
                  child: Column(children: <Widget>[
                    Image.asset('assets/3.jpg', cacheHeight: 200, cacheWidth: 200,),
                    SizedBox(height: 50),
                  ],)
                  ),
                Container(
                  child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(top: 1.0),
                      child: new Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          new Text(
                            '  ',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA),
                            )
                          ),
                          new Text(
                            'Hello World !',
                            style: new TextStyle(
                              fontSize: 35.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA)
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                ),

                Container(
                  child: new Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new Container(
                      padding: new EdgeInsets.only(top: 16.0),
                      child: new Row(
                        children: <Widget>[
                          new Text(
                            '  ',
                            style: new TextStyle(
                              fontSize: 20.0,
                              fontFamily: 'Roboto',
                              color: new Color(0xFF26C6DA),
                            )
                          ),
                        ],
                      ),
                    ),
                    new Text(
                      'I am Dhruv Saini developer of this application.\n\nYou can find me here.',
                      style: new TextStyle(
                        fontSize: 20.0,
                        fontFamily: 'Roboto',
                        color: Colors.black,
                      )
                    ),
                    new Text(''),
                    new Text(''),
                    new Text(''),
                  ],
                ),
                ),
                
                Container(
                  width: MediaQuery.of(context).size.width,
                  child: Column(children: <Widget>[
                    GestureDetector(
                      onTap: () => _launchURLGithub(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 210,
                        alignment: Alignment.center,
                        padding: 
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17, ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE99600),
                          borderRadius: BorderRadius.circular(6)  
                        ),
                        child: Text("Github", style: TextStyle(color: Colors.white))
                      ),
                    ),
                    SizedBox(height: 10),
                    GestureDetector(
                      onTap: () => _launchURLLinkedIN(),
                      child: Container(
                        width: MediaQuery.of(context).size.width - 210,
                        alignment: Alignment.center,
                        padding: 
                          EdgeInsets.symmetric(horizontal: 24, vertical: 17, ),
                        decoration: BoxDecoration(
                          color: Color(0xFFE99600),
                          borderRadius: BorderRadius.circular(6)  
                        ),
                        child: Text("LinkedIN", style: TextStyle(color: Colors.white))
                      ),
                    ),
                  ],
                  )
                ),
              ],
            )
          ),
        );
      }

}