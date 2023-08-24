import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class Homescreen extends StatelessWidget {
  Homescreen({super.key});

  @override
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
        backgroundColor: const Color(0xffB9A706),
        resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(45,),
                  child: Text(
                    welcomeMessage(),
                    style: TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
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
                      "Alcohol Consumption Today",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black
                      ),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 40),
                    child: SfSparkBarChart(
                      labelDisplayMode: SparkChartLabelDisplayMode.all,
                      axisLineColor: Colors.white,
                      data: <double>[
                        10,
                        9,
                        8,
                      ],
                      color: Colors.deepOrange,
                    ),
                  ),
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Morning"),
                          Text("Afternoon"),
                          Text("Evening"),
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
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.black, width: 5)
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child:
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "You are ",
                                style: TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            Text(
                              "ABOVE",
                              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                              Text(
                            " the legal limit for drinking.",
                            style: TextStyle(fontSize: 17,),
                          ),
                            ],
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
  }
