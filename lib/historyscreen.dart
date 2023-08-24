import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';

class historyscreen extends StatelessWidget {
  const historyscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
      ),
      bottomNavigationBar: bottomnav(selectedIndex: 3,),
    );
  }
}
