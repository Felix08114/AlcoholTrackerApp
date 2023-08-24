import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/camerascreen.dart';
import 'package:myalcoholtrackerapp/historyscreen.dart';
import 'package:myalcoholtrackerapp/homescreen.dart';
import 'package:myalcoholtrackerapp/profilescreen.dart';
import 'package:myalcoholtrackerapp/trendscreen.dart';

class bottomnav extends StatefulWidget {
  bottomnav({super.key, required this.selectedIndex, });
int selectedIndex;

  @override
  State<bottomnav> createState() => _bottomnavState();
}

class _bottomnavState extends State<bottomnav> {
  void bottomNavTap(int index){
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Homescreen()));
    }
    if (index == 1) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => profilescreen()));
    }
    if (index == 2) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => camerascreen()));
    }
    if (index == 3) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => historyscreen()));
    }
    if (index == 4) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => trendscreen()));
    }
  }


  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      onTap: bottomNavTap,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: Colors.lightBlue,
      currentIndex: widget.selectedIndex,
      items: const [
        BottomNavigationBarItem(
          icon: (Icon(Icons.home)), label: "Home"
      ),
        BottomNavigationBarItem(
            icon: (Icon(Icons.person)), label: "Profile"
        ),
        BottomNavigationBarItem(
            icon: (Icon(Icons.camera_alt)), label: "Camera"
        ),
        BottomNavigationBarItem(
            icon: (Icon(Icons.punch_clock)), label: "History"
        ),
        BottomNavigationBarItem(
            icon: (Icon(Icons.bar_chart)), label: "Trends"
        ),
      ],
    );
  }
}
