import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';

class profilescreen extends StatelessWidget {
  const profilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 20),
                child: Container(
                height: 75,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 5)
                ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          "Enter name here",
                        style: TextStyle(fontSize: 30),
              ),
                    ),
                  ),
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
              padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 20),
              child: Container(
                height: 75,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.black, width: 5)
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      "Enter age here",
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
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
                padding: const EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 20),
                child: Container(
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 5)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                        "Enter email here",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ),
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
                  height: 75,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.black, width: 5)
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(
                        children: [
                          DropdownButton(items: items, onChanged: onChanged),
                          Text(
                            "Gender",
                            style: TextStyle(fontSize: 30),
                          ),
                        ],
                      ),
                    ),
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
