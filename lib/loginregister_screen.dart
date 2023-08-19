import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/login_screen.dart';
import 'package:myalcoholtrackerapp/signupscreen.dart';
import 'package:myalcoholtrackerapp/utility/buttons.dart';

class loginregistorscreen extends StatelessWidget {
  const loginregistorscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.orangeAccent,
      child: Scaffold(
        backgroundColor: Colors.orange,
        body: Stack(
          children: [Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image:
                AssetImage(
                    "images/champagne.png",
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top:40),
                  child: Center(
                    child: Text("Welcome to  Alcohol Tracker",
                        style: TextStyle(fontSize: 45, color: Colors.orange[100],),
                    ),

                  ),
                ),
                SizedBox(height: 300,),
                Center(
                  child: LoginButton(onPressed: (){
                    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => loginscreen())
                    );
                  }
                  ),
                ),
                SizedBox(height: 30,),
                Center(
                  child:
                  SignupButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => signupscreen())
                      );
                    }, backgroundColor: Colors.white, textcolor: Colors.orange[900],
                  )
                ),
            ],
            ),
          ),
        ],
        ),
      ),
    );
  }
}
