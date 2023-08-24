import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';

class camerascreen extends StatelessWidget {
  const camerascreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
      ),
      bottomNavigationBar: bottomnav(selectedIndex: 2,),
    );
  }
}
