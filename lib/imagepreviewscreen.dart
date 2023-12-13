import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:myalcoholtrackerapp/helper/image_classification_helper.dart';
import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance; //for database
final auth = FirebaseAuth.instance;
late User loggedInUser;
Future<void> getCurrentUser() async {
  try {
    final user = await auth.currentUser;
    if (user != null) {
      loggedInUser = user;
      print(loggedInUser.email);
    }
  }
  catch(e){
    print(e);
  }
}

class imagepreviewscreen extends StatefulWidget {
  const imagepreviewscreen({super.key, required this.picture});
  final XFile picture;

  @override
  State<imagepreviewscreen> createState() => _imagepreviewscreenState();
}

class _imagepreviewscreenState extends State<imagepreviewscreen> {
  late final Interpreter interpreter;
  late Tensor inputTensor;
  late Tensor outputTensor;
  img.Image? image;
  late final List<String> labels;
  bool _isProcessing = false;
  late Map<String, double> classification;
  late ImageClassificationHelper imageClassificationHelper;
  List <bool> lights = [];
  late List<String> finalClassification = [];

  int ouncesEntered = 0;
  String drinkselected = "";
  int count = 0;

  @override
  void initState() {
    super.initState();
    tensorFlowSetup();
    _loadlabels();
    getCurrentUser();
    imageClassificationHelper = ImageClassificationHelper();
    imageClassificationHelper.initHelper();
  }

  List<String> sortClassifications() {
    List<String> sortedResults = [];
    double highestPercentage = 0.0;
    int index = 0;
    int index2 = 0;
    classification.forEach((key, value) {
      if (value > highestPercentage) {
        highestPercentage = value;
        sortedResults.add(key);
        index = index2 + 1;
      }
      else {
        sortedResults.add(key);
      }
      index2++;
    });
    String temp = sortedResults[0];
    sortedResults[0] = sortedResults[index - 1];
    sortedResults[index - 1] = temp;
    return sortedResults;
  }

  @override
  Widget build(BuildContext context) {
    File picturetaken = File(widget.picture.path);
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text("Image Preview"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: Colors.lightBlueAccent,
              width: double.infinity,
              child: Center(
                child: Container(
                  height: MediaQuery
                      .of(context)
                      .size
                      .height / 1.3,
                  color: Colors.lightBlueAccent,
                  child: Image.file(picturetaken),
                ),
              ),
            ),
            Container(
              color: Colors.lightBlueAccent,
              width: double.infinity,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Container(
                    width: double.infinity,
                    child: FloatingActionButton(
                      onPressed: () async {
                        await processImage(picturetaken);
                        print(sortClassifications());
                        finalClassification = sortClassifications();
                        for(int i=0; i < finalClassification.length; i++){
                          lights.add(false);
                        }
                        lights[0] = true;
                        drinkselected = finalClassification[0];
                        _dialogBuilder(context);
                      },
                      child: Text("Analyze",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> tensorFlowSetup() async {
    interpreter = await Interpreter.fromAsset("asset/model.tflite");
    inputTensor = interpreter
        .getInputTensors()
        .first;
    outputTensor = interpreter
        .getOutputTensors()
        .first;
    image = img.decodeImage(await File(widget.picture.path).readAsBytes());
  }

  Future<void> _loadlabels() async {
    final labelText = await rootBundle.loadString("assets/label.txt");
    labels = labelText.split("\n");
  }

  Future<void> processImage(File imagePath) async {
    final imageData = imagePath.readAsBytesSync();
    image = img.decodeImage(imageData);
    setState(() {});
    classification = await imageClassificationHelper.inferenceImage(image!);
    setState(() {});
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Confirm Drinks'),
              content: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  children: [
                    SizedBox(
                      height: 150,
                      width: 300,
                      child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: Row(
                                children: [
                                  Text(finalClassification[index]),
                                Switch(
                                    value: lights [index],
                                    activeColor: Colors.orange,
                                    onChanged: (bool value) {
                                      setState(() {
                                        for (int i=0; i<lights.length; i++){
                                          lights[i] = false;
                                        }
                                        lights [index] = value;
                                        drinkselected = finalClassification[index];
                                      });
                                    }
                                )
                              ]
                            ),
                          );
                        }, separatorBuilder: (BuildContext context, int index) => const Divider(), itemCount: finalClassification.length,
            ),
                    ),
                    TextField(
                      decoration: InputDecoration(hintText: "Enter volume (in oz)"),
                      onChanged: (value){
                        ouncesEntered = int.parse(value);
                      },
                      keyboardType: const TextInputType.numberWithOptions(signed: false, decimal: false),
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme
                        .of(context)
                        .textTheme
                        .labelLarge,
                  ),
                  child: const Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme
                        .of(context).textTheme.labelLarge,
                  ),
                  child: const Text('Ok'),

                  onPressed: () async {

                    print(loggedInUser.email);
                    var docRef = _firestore.collection("drinks").doc(
                        loggedInUser.email);
                    DocumentSnapshot doc = await docRef.get();
                    String date = DateTime.now().toString().split(" ")[0];
                    final data = doc.data() as Map<String, dynamic>;
                    Map<String, int> ouncesAndTime = {DateTime.now().toString(): ouncesEntered};
                    if (data.containsKey(date)){
                      //if we have drink today
                      var data2 = data[date];
                      if (data2.containsKey(drinkselected)) {
                        Map<String, dynamic> drinkData = data2[drinkselected];
                        drinkData[DateTime.now().toString()] = ouncesEntered;
                        Map<String, dynamic> submittedInfo = {drinkselected: drinkData};
                        await docRef.set({date: submittedInfo}, SetOptions(merge: true));
                      } else {
                        Map<String, Map<String, int>> submittedInfo = {drinkselected: ouncesAndTime};
                        await docRef.set({date: submittedInfo}, SetOptions(merge: true));
                      }
                    } else {
                      Map<String, Map<String, int>> submittedInfo = {drinkselected: ouncesAndTime};
                    await docRef.set({date: submittedInfo}, SetOptions(merge: true));
                    }

                    Navigator.popUntil(context, (route) {
                      return count++ ==2;
                    });
                  }
                ),
              ],
            );
          }
        );
      },
    );
  }
}

