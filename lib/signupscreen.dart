import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/homescreen.dart';
import 'package:myalcoholtrackerapp/login_screen.dart';
import 'package:myalcoholtrackerapp/utility/buttons.dart';
import 'package:myalcoholtrackerapp/utility/text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:myalcoholtrackerapp/utility/userInfo.dart';

final _firestore = FirebaseFirestore.instance;

class signupscreen extends StatefulWidget {
  const signupscreen({super.key});

  @override
  State<signupscreen> createState() => _signupscreenState();
}

class _signupscreenState extends State<signupscreen> {
  String name = "";
  String email = "";
  String password = "";
  String confirm_password = "";
  final formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;
 SnackBar snackBar(String error){
   return SnackBar(
     content: Text(error),);
 }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: SpinKitWaveSpinner(
        color: Colors.transparent,
        trackColor: Colors.transparent,
        waveColor: Colors.orange.shade100,
        size: 200,
        duration: const Duration(milliseconds: 1000),
        curve: Curves.bounceInOut,
      ),
      inAsyncCall: showspinner,
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Stack(
            children: [
          Container(
          decoration: const BoxDecoration(
          image: DecorationImage(
            image:
            AssetImage(
            "images/loginsignupbackground.png",
          ),
          fit: BoxFit.cover,
        ),
      ),
      ),
      Form(
        key: formKey,
        child: Column(
        children: [
        SizedBox(
        height: 320,
        ),
          Padding(
            padding: const EdgeInsets.only(left: 8, right: 8, bottom: 20),
            child: TextFormField(
              onChanged: (value) {
                name = value;
              },
              validator: (String? value) {
                if (value != null && value.isNotEmpty)  {
                  return null;}
                else {
                  return "Enter your name";
                }
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,

              decoration: kTextFieldDecoration(),
            ),
          ),
        Padding(
        padding: const EdgeInsets.all(8.0),
        child: TextFormField(
        onChanged: (value) {
        email = value;
        },
          validator: (String? value) {
            if (value != null && value.contains
              ('@') && value.contains('.')) {
              return null;
            }
            else {
              return "Enter a valid email";
            }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,

        decoration: kTextFieldDecoration().copyWith(hintText: " Email"),
        ),
        ),
        Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 20.0, bottom: 30),
        child: TextFormField(
        onChanged: (value) {
        password = value;
        },
          validator: (String? value){
        if (value != null && value.length<5) {
        return "Password must be at least 6 characters";}
        else {
          return null;
        }
          },
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscureText: true,
          autocorrect: false,
          decoration: kTextFieldDecoration().copyWith(hintText: " Password"),
        ),
        ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 30),
            child: TextFormField(
              onChanged: (value) {
               confirm_password = value;
              },
              validator: (String? value) {
                if (value == password) {
                  return null;
                }
                else {return "Passwords do not match";}
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              obscureText: true,
              autocorrect: false,
              decoration: kTextFieldDecoration().copyWith(hintText: " Confirm password"),
            ),
          ),
        Center(
        child:
        SignupButton(onPressed: () async {

          if (formKey.currentState!.validate()){
            setState(() {
            showspinner = true;
          });
            try{
              final newUser = await _auth.createUserWithEmailAndPassword(
                  email: email, password: password);
          if(newUser != null) {
            await _firestore.collection("drinks").doc(email).set({});
            await _firestore.collection("userData").doc(email).set({
            'Name' : name,
            'Gender' : "Prefer not to say",
            'Weight' : 1,
            });
            user_Info_Name = name;
            user_Info_gender = "Prefer not to say";
            user_Info_Weight = 1;
          Navigator.push(context,
          MaterialPageRoute(
          builder:
          (context) =>
          (Homescreen())));
          }
            }
            catch(e){
              print(e);
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBar(e.toString().split(']')[1]
              ));
            }
            setState(() {
              showspinner = false;});
          }
        }, backgroundColor: Colors.orange[700], textcolor: Colors.orange[100],),
        ),
        Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, bottom: 20),
                child: Row(
                  children: [
                    Text("Already have an account?", style: TextStyle(fontSize: 15),),
                    GestureDetector(
                      onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context) => loginscreen()));},
                      child: Text(" Log in.",
                        style: TextStyle(fontSize: 15, color: Colors.orange),),
                    ),
                  ],
                ),
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
