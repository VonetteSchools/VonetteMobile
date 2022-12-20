// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:intl/intl.dart';

class EventDetails extends StatefulWidget {
  bool editable;
  DateTime? selectedDay;
  String? classValue;
  String? title;
  DateTime? date;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  String? description;
  EventDetails(
      {Key? key,
      required this.editable,
      this.selectedDay,
      this.classValue,
      this.title,
      this.date,
      this.startTime,
      this.endTime,
      this.description})
      : super(key: key);

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController dateInput = TextEditingController();
  TextEditingController timeInput = TextEditingController();
  TextEditingController timeInput2 = TextEditingController();
  DateTime actualDate = DateTime.now();

  void initState() {
    dateInput.text =
        DateFormat('MM-dd-yyyy').format(widget.selectedDay ?? widget.date!);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInApp?>(context);
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;

    if (widget.startTime != null) {
      setState(() {
        timeInput.text = widget.startTime!.format(context);
        timeInput2.text = widget.endTime!.format(context);
      });
    }
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: width_sc,
          height: heigth_sc,
          padding: const EdgeInsets.all(20),
          color: Colors.white,
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const DefaultTextStyle(
                        style: TextStyle(color: Colors.black, fontSize: 20),
                        child: Text('Add Event'),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        backgroundColor: Colors.white,
                        elevation: 0,
                        child: const Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      )
                    ]),
                StreamBuilder(
                    stream: DatabaseService(user: user).updateClubSnapshot,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data.docs.isEmpty) {
                          return const Center(child: Text('No Clubs For Now!'));
                        }
                        return DropdownButtonFormField(
                          decoration: InputDecoration(
                            labelText: 'Class/Club',
                            icon: const Icon(Icons.class_rounded,
                                color: Colors.black),
                            labelStyle: const TextStyle(color: Colors.black),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                  color: widget.editable
                                      ? Colors.black
                                      : Colors.grey),
                            ),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black)),
                          ),
                          value: widget.classValue,
                          items: List.generate(
                              snapshot.data.docs.length,
                              (index) => DropdownMenuItem(
                                  value: snapshot.data.docs[index]['club_name'],
                                  child: Text(
                                      snapshot.data.docs[index]['club_name']))),
                          onChanged: widget.editable
                              ? (value) {
                                  widget.classValue = value as String?;
                                }
                              : null,
                        );
                      }
                      return const LinearProgressIndicator();
                    }),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  style: TextStyle(
                      color: widget.editable ? Colors.black : Colors.grey),
                  enabled: widget.editable,
                  initialValue: widget.title,
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      labelText: 'Title',
                      icon: Icon(Icons.title_rounded, color: Colors.black)),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter some text';
                    }
                    return null;
                  },
                  onChanged: (value) => widget.title = value,
                ),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: TextFormField(
                  style: TextStyle(
                      color: widget.editable ? Colors.black : Colors.grey),
                  enabled: widget.editable,
                  controller: dateInput,
                  decoration: const InputDecoration(
                      labelStyle: TextStyle(color: Colors.black),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      icon: Icon(Icons.calendar_today, color: Colors.black),
                      labelText: "Enter Date"),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: widget.selectedDay ?? widget.date!,
                      firstDate: DateTime(1950),
                      lastDate: DateTime(2100),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                onSurface: Colors.black),
                            textButtonTheme: TextButtonThemeData(
                              style:
                                  TextButton.styleFrom(primary: Colors.black),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      String formattedDate =
                          DateFormat('MM-dd-yyyy').format(pickedDate);
                      setState(() {
                        dateInput.text = formattedDate;
                        actualDate = pickedDate;
                      });
                    } else {}
                  },
                )),
                const SizedBox(height: 20),
                Center(
                    child: TextFormField(
                  style: TextStyle(
                      color: widget.editable ? Colors.black : Colors.grey),
                  enabled: widget.editable,
                  controller: timeInput,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.timer_sharp,
                      color: Colors.black,
                    ),
                    labelText: "Start Time",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: widget.startTime != null
                          ? widget.startTime!
                          : TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                onSurface: Colors.black),
                            textButtonTheme: TextButtonThemeData(
                              style:
                                  TextButton.styleFrom(primary: Colors.black),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedTime != null) {
                      String formattedTime = pickedTime.format(context);
                      setState(() {
                        timeInput.text = formattedTime;
                      });
                    }
                  },
                )),
                const SizedBox(
                  height: 20,
                ),
                Center(
                    child: TextFormField(
                  style: TextStyle(
                      color: widget.editable ? Colors.black : Colors.grey),
                  enabled: widget.editable,
                  controller: timeInput2,
                  decoration: const InputDecoration(
                    icon: Icon(
                      Icons.timer_sharp,
                      color: Colors.black,
                    ),
                    labelText: "End Time",
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  readOnly: true,
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: widget.endTime != null
                          ? widget.endTime!
                          : TimeOfDay.now(),
                      initialEntryMode: TimePickerEntryMode.input,
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: Colors.deepPurple,
                                onPrimary: Colors.white,
                                onSurface: Colors.black),
                            textButtonTheme: TextButtonThemeData(
                              style:
                                  TextButton.styleFrom(primary: Colors.black),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );

                    if (pickedTime != null) {
                      String formattedTime = pickedTime.format(context);
                      setState(() {
                        timeInput2.text = formattedTime;
                      });
                    }
                  },
                )),
                const SizedBox(height: 20),
                TextFormField(
                  style: TextStyle(
                      color: widget.editable ? Colors.black : Colors.grey),
                  enabled: widget.editable,
                  initialValue: widget.description,
                  maxLines: null,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.black),
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    labelText: 'Description (Optional)',
                    alignLabelWithHint: true,
                    icon: Icon(
                      Icons.description_outlined,
                      color: Colors.black,
                    ),
                  ),
                  onChanged: (value) => widget.description = value,
                ),
                Padding(
                  padding: EdgeInsets.only(top: heigth_sc - 650),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.deepPurple,
                        ),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (widget.editable) {
                              widget.classValue ??= 'Other';
                              widget.description ??= 'No Description';
                              if (timeInput.text == "") {
                                timeInput.text =
                                    TimeOfDay.now().format(context);
                              }
                              if (timeInput2.text == "") {
                                timeInput2.text =
                                    TimeOfDay.now().format(context);
                              }

                              DatabaseService(user: user).createCalendarEvents(
                                  actualDate.day,
                                  actualDate.year,
                                  actualDate.month,
                                  widget.title,
                                  timeInput.text,
                                  timeInput2.text,
                                  widget.classValue,
                                  widget.description);
                              Navigator.pop(context);
                            } else {
                              setState(() {
                                widget.editable = true;
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                          primary: Colors.deepPurple,
                        ),
                        child: widget.editable
                            ? const Text('Submit')
                            : const Text('Edit'),
                      )
                    ],
                  ),
                )
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
