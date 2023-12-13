import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:intl/intl.dart';
import 'package:myalcoholtrackerapp/historyscreen.dart';
import 'package:myalcoholtrackerapp/utility/calculatingBAC.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:jiffy/jiffy.dart';

final _firestore = FirebaseFirestore.instance;
final auth = FirebaseAuth.instance;
late User loggedinUser;

class Homescreen extends StatefulWidget {
  Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  int currentBAC = 90;
  String todaysDate = "";
  String firstDayOfWeek = "";
  List<int> weeklyLog = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todaysDate = DateTime.now().toString().split(" ")[0];
    firstDayOfWeek = DateTime.now().subtract(Duration(days: DateTime.now().weekday)).toString().split(" ")[0];
    getWeeklyLog(firstDayOfWeek);
  }

  getWeeklyLog(String day) async{
    try {
      final user = await auth.currentUser;
      if (user != null){
        loggedInUser = user;
      }
      var docRef = _firestore.collection("drinks").doc(loggedInUser.email);
      DocumentSnapshot doc = await docRef.get();
      final data = await doc.data() as Map<String, dynamic>;

      for(int i=0; i<7; i++){
    if (data.keys.contains(day)){
          int sum = 0;
          data[day].forEach((drinkType, timeAndAmount){
           timeAndAmount.forEach((time,amount){
           sum += amount as int;
           });
          });
          setState(() {
            weeklyLog.add(sum);
          });
        }
        else{
          setState(() {
            weeklyLog.add(0);
          });
        }
        DateTime nextDay = DateTime.parse(day + " 10:00:00.000");
    nextDay = Jiffy.parseFromDateTime(nextDay).add(days: 1).dateTime;
    day = nextDay.toString().split(" ")[0];
      }


    } catch (e) {
      print(e);
    }
  }

  Widget build(BuildContext context) {
    DateTime now =DateTime.now();
    String formattedDate = DateFormat('kk:mm:ss \n EEE d MMM').format(now);
    int currentHour = int.parse(formattedDate.split(':')[0]);
    String welcomeMessage(){
      if(currentHour <= 12){
        return "Good morning";
      }
      if(currentHour > 12 && currentHour < 18){
        return "Good afternoon";
      }
      else {
        return "Good evening";
      }
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xffebd009),
        resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(10,),
                  child: Text(
                    welcomeMessage(),
                    style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 5)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("$todaysDate", style: TextStyle(color: Colors.black, fontSize: 30),)
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 5)
                  ),
                alignment: Alignment.topCenter,
                child: Column(
                  children: [
                    Text(
                      "Alcohol Consumption This Week",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 50),
                    child: SfSparkBarChart(
                      labelStyle: TextStyle(fontSize: 15),
                      labelDisplayMode: SparkChartLabelDisplayMode.all,
                      axisLineColor: Colors.white,
                      data: weeklyLog.isNotEmpty ? weeklyLog : [0, 0, 0, 0, 0, 0, 0],
                      color: Colors.deepOrange,
                    ),
                  ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Mon"),
                          Text("Tue"),
                          Text("Wed"),
                          Text("Thur"),
                          Text("Fri"),
                          Text("Sat"),
                          Text("Sun"),
                        ],
                      ),
                    )
                  ],

                ),
                ),
              ),
                Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
                child: Container(
                height: 60,
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 5)
                    ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FutureBuilder<String>(
                          future: getBloodAlcoholLevel(),
                          builder: (context, snapshot) {
                            return Text(
                              "Current BAC: ${snapshot.data}%",
                              style: TextStyle(
                                fontSize: 30,
                              ),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, top: 40),
                  child: Container(
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 5)
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child:
                          FutureBuilder<String>(
                            future: getBloodAlcoholLevel(),
                            builder: (context, snapshot) {
                              if(snapshot.hasData) {
                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "You are ",
                                      style: TextStyle(
                                        fontSize: 17,
                                      ),
                                    ),
                                    Text(
                                      double.parse(snapshot.data!) > 0.08
                                          ? "ABOVE"
                                          : "BELOW",
                                      style: TextStyle(fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      " the legal limit for driving.",
                                      style: TextStyle(fontSize: 17,),
                                    ),
                                  ],
                                );
                              } else {
                                return Container();
                              }
                            }
                          ),
                        ),
                          ],
                    ),

                  ),
                ),
            ],
        ),
        bottomNavigationBar: bottomnav(selectedIndex: 0,)
      ),
    );
  }

  Container datePicker(){
    return Container(
      height: 300,
      width: 300,
      child: SfDateRangePicker(
      initialSelectedDate: DateTime.now(),
        onSubmit: (value){
        Navigator.pop(context);
        },
        onCancel: (){
        Navigator.pop(context);
        },
      ),
    );
  }
}
