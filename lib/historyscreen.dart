import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:table_calendar/table_calendar.dart';
import 'utility/calenderutil.dart';

final _firestore = FirebaseFirestore.instance; //for database
final auth = FirebaseAuth.instance;
late User loggedInUser;

class historyscreen extends StatefulWidget {
  const historyscreen({super.key});

  @override
  State<historyscreen> createState() => _historyscreenState();
}

class _historyscreenState extends State<historyscreen> {
  DateTime? _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  ValueNotifier<List<Event>> _selectedEvents = ValueNotifier([Event("")]);

  var events = LinkedHashMap<DateTime, List<Event> >(
    equals: isSameDay,
    hashCode: getHashCode,
  );

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _selectedDay = _focusedDay;
  }

getDrinkHistory() async {
  events = LinkedHashMap<DateTime, List<Event> >(
    equals: isSameDay,
    hashCode: getHashCode,
  )..addAll(await getDrinks());
  _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
}

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: FutureBuilder(
            future: getDrinkHistory(),
            builder: (context, AsyncSnapshot<dynamic> snapshot) {
              return Column(
                children: [
                  TableCalendar(
                    firstDay: DateTime.utc(2010, 10, 16),
                    lastDay: DateTime.utc(2030, 3, 14),
                    focusedDay: _focusedDay,
                    eventLoader: (day) {
                      return _getEventsForDay(day);
                    },
                    availableCalendarFormats: {CalendarFormat.month:'Month',},
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },

                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                      _selectedEvents.value = _getEventsForDay(selectedDay);
                    },
                  ),
                  const SizedBox(height: 8.0),
                  Expanded(
                    child: ValueListenableBuilder<List<Event>>(
                      valueListenable: _selectedEvents,
                      builder: (context, value, _) {
                        return ListView.builder(
                          itemCount: value.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12.0,
                                vertical: 4.0,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: ListTile(
                                onTap: () => print('${value[index]}'),
                                title: Text('${value[index]}'),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            }
          ),
          bottomNavigationBar: bottomnav(selectedIndex: 3,),
        ),
      ),
    );
  }

  getDrinks() async {
    LinkedHashMap<DateTime, List<Event>> events = LinkedHashMap();
    List<Event> listOfDrinks = [];

    try {
      final user = await auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        }
      var docRef = _firestore.collection("drinks").doc(loggedInUser.email);
      DocumentSnapshot doc = await docRef.get();
      final data = await doc.data() as Map<String, dynamic>;

      data.forEach((key, value) {
        data[key].forEach((innerkey, innervalue){
          listOfDrinks.add(Event("$innerkey: ${innervalue.toString()} oz"));
        });
      events[DateTime.parse("$key 00:00:00.000")] = listOfDrinks.toList();
      listOfDrinks.clear();
      });
    }
    catch(e){
      print(e);
    }
    return events;
  }
}
