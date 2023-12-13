import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:myalcoholtrackerapp/utility/text_fields.dart';
import 'package:myalcoholtrackerapp/utility/userInfo.dart';

import 'historyscreen.dart';

const List<String> list = <String> [
  'Male',
  'Female',
  'Prefer not to say',
];

final auth = FirebaseAuth.instance;
final FlutterSecureStorage _storage = FlutterSecureStorage();
int count = 0;
late User loggedinUser;
final _firestore = FirebaseFirestore.instance;
final weightTextController = TextEditingController();


class profilescreen extends StatefulWidget {
  const profilescreen({super.key});

  @override
  State<profilescreen> createState() => _profilescreenState();

}

class _profilescreenState extends State<profilescreen> {
  String dropdownValue = user_Info_gender;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    getUserInfo();
    weightTextController.text = user_Info_Weight.toString();
  }


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
                 child: Text(user_Info_Name,
                 style: TextStyle(
                   fontSize: 20
                 ),),
               ),
              Padding(
        padding: const EdgeInsets.only(top: 20, left: 10),
        child: Text("Weight",
          style: TextStyle(
              fontSize: 25
          ),
        ),
      ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: TextField(
                  onSubmitted: (value){
                    _firestore.collection("userData").doc(auth.currentUser?.email).update({
                      "Weight" : int.parse(value),
                    });
                    user_Info_Weight = int.parse(value);
                  },
                  controller: weightTextController,
                  keyboardType: TextInputType.number,
                  decoration: kTextFieldDecoration().copyWith(hintText: "Enter your weight")
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
                child: Text("Edit Email",
                  style: TextStyle(
                      fontSize: 25
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Text(auth.currentUser?.email??""),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20, left: 10),
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
                                _firestore.collection("userData").doc(auth.currentUser?.email).update({
                                  "Gender" : value,
                                });
                                user_Info_gender = value;
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
                child: ElevatedButton(onPressed: () async {
                  auth.signOut();
                  await _storage.deleteAll();
                  Navigator.popUntil(context, (route) {
                    return count++ ==2;
                  });
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
