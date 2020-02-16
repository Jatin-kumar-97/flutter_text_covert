import 'dart:io';

import 'package:translator/translator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _languages = [
    'English',
    'Hindi',
    'Gujarati',
    'Telugu',
    'Marathi',
    'French',
    'Malyalam',
    'Urdu',
    'Kannada',
    'Nepali',
    'Bangali',
    'Tamil',
    'Korean',
    'Russian',
    'Hungarian',
    'Portuguese',
    'Dutch',
    'German',
    'Spanish',
    'Italian'
  ];
  String data = "Your text will appear here!!!", _currentLang = 'English';
  String _lcode = 'en';
//  final LanguageIdentifier languageIdentifier = FirebaseLanguage.instance.languageIdentifier();
  final translator = new GoogleTranslator();
  File pickedImage;
  bool isImageLoaded = false;
  bool isSpeakStart = false;
  final FlutterTts flutterTts = FlutterTts();

  _openGallery(BuildContext context) async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (tempStore != null) {
      setState(() {
        pickedImage = tempStore;
        isImageLoaded = true;
      });
    } else {
      Fluttertoast.showToast(msg: 'Please select an image');
    }
    Navigator.of(context).pop();
  }

  _openCamera(BuildContext context) async {
    var tempStore = await ImagePicker.pickImage(source: ImageSource.camera);
    if (tempStore != null) {
      setState(() {
        pickedImage = tempStore;
        isImageLoaded = true;
      });
    } else {
      Fluttertoast.showToast(msg: 'Please select an image');
    }
    Navigator.of(context).pop();
  }

  Future pickImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Choose From"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _openCamera(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(12.0)),
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _openGallery(context);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future readText() async {
    FirebaseVisionImage ourImage = FirebaseVisionImage.fromFile(pickedImage);
    TextRecognizer recognizeText = FirebaseVision.instance.textRecognizer();
    VisionText readText = await recognizeText.processImage(ourImage);

    //  data = readText.text;
    //final input = "Bitch";
    translator.translate(readText.text, from: 'en', to: _lcode).then((s) {
      //print(s);
      setState(() {
        data = s.toString();
        Container();
      });
    });
  }

  Future _speak() async {
    setState(() {
      this.isSpeakStart = true;
    });
    if (data == "Your text will appear here!!!") {
      Fluttertoast.showToast(msg: 'First of all select an image');
      setState(() {
        this.isSpeakStart = false;
      });
    }

    //print(await flutterTts.getLanguages);
    //print(await flutterTts.getVoices);
    await flutterTts.setLanguage(_lcode);
    await flutterTts.speak(data);

    // await flutterTts.speak(data).whenComplete(_stop);
  }

  Future _stop() async {
    flutterTts.stop();
    setState(() {
      this.isSpeakStart = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        isImageLoaded
            ? Center(
                child: SafeArea(
                  child: Container(
                    height: 400.0,
                    width: 300.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: FileImage(pickedImage), fit: BoxFit.fitHeight),
                    ),
                  ),
                ),
              )
            : Container(),
        SizedBox(height: 40.0),
        RaisedButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(8.0),
              side: BorderSide(color: Colors.blue)),
          child: Text('Pick an image'),
          onPressed: () {
            pickImage(context);
          },
          color: Colors.blue,
          textColor: Colors.white,
        ),
        SizedBox(height: 10.0),
        SingleChildScrollView(
          child: DropdownButton<String>(
            items: _languages.map((String dropdownStringItem) {
              return DropdownMenuItem<String>(
                value: dropdownStringItem,
                child: Text(dropdownStringItem),
              );
            }).toList(),
            onChanged: (String newValueSelected) {
              setState(() {
                if (newValueSelected == 'English') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'en';
                } else if (newValueSelected == 'Hindi') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'hi';
                } else if (newValueSelected == 'Gujarati') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'gu';
                } else if (newValueSelected == 'Telugu') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'te';
                } else if (newValueSelected == 'French') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'fr';
                } else if (newValueSelected == 'Malyalam') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'ml';
                } else if (newValueSelected == 'Urdu') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'ur';
                } else if (newValueSelected == 'Bangali') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'bn';
                } else if (newValueSelected == 'Tamil') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'ta';
                } else if (newValueSelected == 'Marathi') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'mr';
                } else if (newValueSelected == 'Kannada') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'kn';
                } else if (newValueSelected == 'Nepali') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'ne';
                } else if (newValueSelected == 'Marathi') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'mr';
                } else if (newValueSelected == 'Korean') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'ko';
                } else if (newValueSelected == 'Russian') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'ru';
                } else if (newValueSelected == 'Hungarian') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'hu';
                } else if (newValueSelected == 'Portuguese') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'pt';
                } else if (newValueSelected == 'Dutch') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'nl';
                } else if (newValueSelected == 'Portuguese') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'pt';
                } else if (newValueSelected == 'German') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'de';
                } else if (newValueSelected == 'Spanish') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'us';
                } else if (newValueSelected == 'Italian') {
                  this._currentLang = newValueSelected;
                  this._lcode = 'it';
                }
              });
            },
            value: _currentLang,
          ),
        ),
        RaisedButton(
          child: Text('Read Text'),
          onPressed: readText,
          shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.blue),
          ),
          color: Colors.blue,
          textColor: Colors.white,
        ),
        Center(
          child: Container(
            height: 150,
            width: 300.0,
            color: Colors.grey[200],
            child: SingleChildScrollView(child: Text(data.toString())),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            isSpeakStart
                ? FloatingActionButton(
                    onPressed: () => _stop(),
                    child: Icon(Icons.pause),
                  )
                : FloatingActionButton(
                    child: Icon(Icons.play_arrow),
                    onPressed: () => _speak(),
                  ),
          ],
        )
      ],
    ));
  }
}
