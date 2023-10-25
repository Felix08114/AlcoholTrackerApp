import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:myalcoholtrackerapp/utility/text_fields.dart';

const List<String> list = <String> [
  'Male',
  'Female',
  'Prefer not to say',
];

final auth = FirebaseAuth.instance;

class profilescreen extends StatefulWidget {
  const profilescreen({super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();
}

class _profilescreenState extends State<profilescreen> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Text("Name",
                style: TextStyle(
                  fontSize: 25
                ),
                ),
              ),
               Padding(
                 padding: const EdgeInsets.only(left: 10, right: 10),
                 child: TextField(
                      onChanged: (value) {},
                      autocorrect: false,
                        decoration: kTextFieldDecoration().copyWith(hintText: "Enter your name")
                    ),
               ),
              Padding(
        padding: const EdgeInsets.only(top: 20, left: 10),
        child: Text("Age",
          style: TextStyle(
              fontSize: 25
          ),
        ),
      ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                    onChanged: (value) {},
                    autocorrect: false,
                    decoration: kTextFieldDecoration().copyWith(hintText: "Enter your age")
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Text("Email",
                  style: TextStyle(
                      fontSize: 25
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                    onChanged: (value) {},
                    autocorrect: false,
                    decoration: kTextFieldDecoration().copyWith(hintText: "Edit email")
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Text("Gender",
                  style: TextStyle(
                      fontSize: 25
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 20),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.brown[100] ,
                      borderRadius: BorderRadius.circular(21),
                      border: Border.all(color: Colors.blueAccent, width: 2)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          DropdownButton<String>(
                            value: dropdownValue,
                            icon: Icon(Icons.arrow_drop_down),
                            elevation: 16,
                            style: TextStyle(color: Colors.black, fontSize: 25),
                            onChanged: (String? value) {
                              setState(() {
                                dropdownValue = value!;
                              });
                              },
                            items: list.map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
              ),
              Center(
                child: ElevatedButton(onPressed: () {
                  auth.signOut();
                  Navigator.pop(context);
                },
                  child: Text("Sign out",
                  style: TextStyle(fontSize: 50, color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      bottomNavigationBar: bottomnav(selectedIndex: 1,),
    );
  }
}
