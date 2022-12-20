// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, no_leading_underscores_for_local_identifiers
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/calendar/event_details.dart';
import 'package:vonette_mobile/services/authentication.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:provider/provider.dart';

class Calendar extends StatefulWidget {
  final Function? togglePage;
  final Function? toggleLoad;
  const Calendar({this.togglePage, this.toggleLoad});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInApp?>(context);
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    int counter = 0;

    return Scaffold(
      // appBar: PreferredSize(preferredSize: Size.fromHeight(heigth_sc*0.07), child: AppBar(
      //   centerTitle: true, title: const Text("Calendar"), flexibleSpace: Container(decoration: purpleGradient), actions: [
      //     IconButton(onPressed: () {_auth.signOut();}, icon: const Icon(Icons.logout_outlined, color: Colors.black))
      //   ],)),
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Calendar",
          style: TextStyle(
              color: headingTextColor,
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
        //toolbarHeight: heigth_sc * 0.10,
        flexibleSpace:
            Container(decoration: const BoxDecoration(color: backgroundColor)),
        elevation: 0,
        actions: [
          FutureBuilder(
              future: DatabaseService(user: user).getClubNameList,
              builder: (context, AsyncSnapshot snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 9, top: 4),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentPurple,
                    ),
                    child: IconButton(
                      onPressed: () {
                        showEventDialog(
                          context,
                          true,
                          _selectedDay,
                        );
                      },
                      icon: const Icon(Icons.add),
                      iconSize: 22,
                    ),
                  ),
                );
              })
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
              firstDay: DateTime(2017),
              lastDay: DateTime(2117),
              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDay, selectedDay)) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              startingDayOfWeek: StartingDayOfWeek.sunday,
              headerStyle: const HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
              )),
          const SizedBox(height: 8.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: StreamBuilder(
                stream: DatabaseService(user: user).getCalendarStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data.docs.isEmpty) {
                      return const Center(
                          child: Text('No Events For This Day!'));
                    }
                    return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          if ((snapshot.data.docs[index]['date_year'] ==
                                  _selectedDay!.year) &&
                              (snapshot.data.docs[index]['date_month'] ==
                                  _selectedDay!.month) &&
                              (snapshot.data.docs[index]['date_day'] ==
                                  _selectedDay!.day)) {
                            counter += 1;
                            return ListTile(
                                leading: const Icon(Icons.calendar_month),
                                title: Text(
                                    '${snapshot.data.docs[index]['chosen_start_time']} - ${snapshot.data.docs[index]['chosen_end_time']}: ${snapshot.data.docs[index]['chosen_club']}'),
                                subtitle: Text(
                                    '${snapshot.data.docs[index]['chosen_title']}: ${snapshot.data.docs[index]['description']}'),
                                trailing: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () => DatabaseService(user: user)
                                        .deleteCalendarEvents(snapshot
                                            .data.docs[index]['event_uid'])));
                          }
                          if (counter == 0) {
                            return const Center(
                                heightFactor: 15,
                                child: Text('No Events For This Day!'));
                          }
                          return const SizedBox.shrink();
                        });
                  }
                  return const LinearProgressIndicator();
                },
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        color: barColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.only(left: 16),
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(1);
                      widget.toggleLoad;
                    },
                    icon: const Icon(
                      Icons.groups_rounded,
                      color: Colors.black,
                      size: 25,
                    ))),
            Container(
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(2);
                      widget.toggleLoad;
                    },
                    icon: const Icon(Icons.textsms_rounded,
                        color: Colors.black, size: 25))),
            Container(
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(3);
                      widget.toggleLoad;
                    },
                    icon: const Icon(Icons.calendar_month_sharp,
                        color: Colors.deepPurple, size: 25))),
            Container(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(4);
                      widget.toggleLoad;
                    },
                    icon: const Icon(Icons.settings,
                        color: Colors.black, size: 25)))
          ],
        ),
      ),
    );
  }
}

showEventDialog(BuildContext context, bool editable, DateTime? selectedDay,
    {String? classValue,
    String? title,
    DateTime? date,
    TimeOfDay? startTime,
    String? description}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 200),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return EventDetails(
        editable: editable,
        selectedDay: selectedDay,
        classValue: classValue,
        title: title,
        date: date,
        startTime: startTime,
        description: description,
      );
    },
  );
}
