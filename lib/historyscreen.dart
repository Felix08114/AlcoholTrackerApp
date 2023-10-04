import 'package:flutter/material.dart';
import 'package:myalcoholtrackerapp/bottomnav.dart';
import 'package:table_calendar/table_calendar.dart';

class historyscreen extends StatefulWidget {
  const historyscreen({super.key});

  @override
  State<historyscreen> createState() => _historyscreenState();
}

class _historyscreenState extends State<historyscreen> {
  DateTime? _selectedDay;
   DateTime _focusedDay = DateTime.now();


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.utc(2030, 3, 14),
          focusedDay: _focusedDay,
          availableCalendarFormats: {CalendarFormat.month:'Month',},
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
            });
          },
        ),
        bottomNavigationBar: bottomnav(selectedIndex: 3,),
      ),
    );
  }
}
