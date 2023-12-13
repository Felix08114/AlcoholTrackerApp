import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/homescreen.dart';
import 'package:myalcoholtrackerapp/profilescreen.dart';
import 'package:myalcoholtrackerapp/signupscreen.dart';
import 'package:myalcoholtrackerapp/utility/buttons.dart';
import 'package:myalcoholtrackerapp/utility/text_fields.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:myalcoholtrackerapp/utility/userInfo.dart';



class loginscreen extends StatefulWidget {
  const loginscreen({super.key});

  @override
  State<loginscreen> createState() => _loginscreenState();
}

class _loginscreenState extends State<loginscreen> {
  String email = "";
  String password = "";
  final _auth = FirebaseAuth.instance;
  bool showspinner = false;
  final FlutterSecureStorage _storage = FlutterSecureStorage();
  final emailTextController = TextEditingController();
  final passwordTextController = TextEditingController();
  late Map<String, String> savedUsernamePassword;

  @override
  void initState() {
    super.initState();
    _storage.readAll();
    fetchSecureStorageData();
  }
  fetchSecureStorageData() async {
    Map<String, String> loginCredentials = await _storage.readAll();
    email = loginCredentials.keys.toList().first;
    password = loginCredentials[email]!;
    emailTextController.text = loginCredentials.keys.toList().first;
    passwordTextController.text = loginCredentials[email]!;
    print(email);
    print(password);
  }

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
            Column(
              children: [
                SizedBox(
                  height: 320,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: emailTextController,
                    onChanged: (value) {
                      email = value;
                    },
                    autocorrect: false,
                    keyboardType: TextInputType.emailAddress,

                    decoration: kTextFieldDecoration().copyWith(hintText: " Email"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 30.0, bottom: 30),
                  child: TextField(
                    controller: passwordTextController,
                      onChanged: (value) {
                        password = value;
                      },
                    obscureText: true,
                    autocorrect: false,
                      decoration: kTextFieldDecoration().copyWith(hintText: " Password"),
                  ),
                ),
                Center(
                  child:LoginButton(onPressed: () async {
                    setState(() {
                      showspinner = true;
                    });
                    try{
                      final user = await _auth.signInWithEmailAndPassword(
                        email: email, password: password,
                      );
                      if (user != null) {
                        await _storage.write(key: email, value: password);
                        await getUserInfo();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                            builder: (context) => Homescreen()));
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
                  ),
                ),
                TextButton(onPressed: () {},
                    child: Text(
                      "Forgot password?",
                      style: TextStyle(color: Colors.orange, fontSize: 20),
                    ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, bottom: 20,),
                      child: Row(
                        children: [
                          Text("Don't have an account?", style: TextStyle(fontSize: 15),),
                          GestureDetector(
                            onTap: () {Navigator.pushReplacement(context, MaterialPageRoute(
                                builder: (context) => signupscreen()));
                              },
                            child: Text(" Create one.",
                            style: TextStyle(fontSize: 15, color: Colors.orange),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            ],
          ),
        ),
      ),
    );
  }
}
