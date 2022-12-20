// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/settings/createClubs/addClub.dart';
import 'package:vonette_mobile/screens/home/settings/editProfile.dart';
import 'package:vonette_mobile/services/authentication.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:vonette_mobile/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/shared/constants.dart';

class SettingsPage extends StatefulWidget {
  final Function? togglePage;
  final Function? toggleLoad;
  const SettingsPage({this.togglePage, this.toggleLoad});

  // creates background task which states which page is running
  // notice that button runs the toggleView functions from authen.dart that
  // switches between the register and sign in page.
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  final fieldTextController = TextEditingController();
  final fieldTextController2 = TextEditingController();

  Color c1 = const Color(0xF6F6F6);

  String password = '';
  String conf_password = '';
  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);

    return loading
        ? const Loading()
        : Scaffold(
            body: SingleChildScrollView(
                child: StreamBuilder(
                    stream: DatabaseService(user: user).getCurrentUserDM,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        var name = snapshot.data['username'];
                        var email = snapshot.data['email'];
                        var imageUrl = snapshot.data['profile_url'];
                        return Form(
                            key: _formKey,
                            child: Column(children: [
                              Container(
                                  height: heigth_sc * 0.290,
                                  width: width_sc,
                                  color: Colors.white,
                                  child: Column(children: [
                                    const SizedBox(height: 60),
                                    CircleAvatar(
                                        radius: 30,
                                        backgroundImage:
                                            NetworkImage(imageUrl)),
                                    const SizedBox(height: 10),
                                    Text('$name',
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 21)),
                                    const SizedBox(height: 5),
                                    Text('$email'),
                                    const SizedBox(height: 5),
                                    SizedBox(
                                      width: width_sc * 0.335,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: const Color.fromARGB(
                                              255, 144, 98, 224),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      const EditProfile())));
                                        },
                                        child: const Text('Edit Profile'),
                                      ),
                                    )
                                  ])),
                              Container(
                                  width: width_sc,
                                  height: heigth_sc * 0.71,
                                  color: c1,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            width_sc * 0.03,
                                            heigth_sc * 0.02,
                                            0,
                                            heigth_sc * 0.005),
                                        child: const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Content',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16))),
                                      ),
                                      SizedBox(
                                        width: width_sc,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shadowColor: Colors.transparent,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.push_pin_outlined,
                                                color: Color.fromARGB(
                                                    255, 125, 123, 123),
                                                size: 20,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7, 0, 0, 0),
                                                child: Text('Pinned Messages',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: heigth_sc * 0.001,
                                      ),
                                      SizedBox(
                                        width: width_sc,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shadowColor: Colors.transparent,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: () {},
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.report_problem_outlined,
                                                color: Color.fromARGB(
                                                    255, 125, 123, 123),
                                                size: 20,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7, 0, 0, 0),
                                                child: Text('Report a Bug/User',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: heigth_sc * 0.001,
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            width_sc * 0.03,
                                            heigth_sc * 0.02,
                                            0,
                                            heigth_sc * 0.005),
                                        child: const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Create a Club',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16))),
                                      ),
                                      SizedBox(
                                        width: width_sc,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shadowColor: Colors.transparent,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        AddClub(
                                                            private: false))));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.add_outlined,
                                                color: Color.fromARGB(
                                                    255, 125, 123, 123),
                                                size: 20,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7, 0, 0, 0),
                                                child: Text('Add a Club',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: heigth_sc * 0.001,
                                      ),
                                      SizedBox(
                                        width: width_sc,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shadowColor: Colors.transparent,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        AddClub(
                                                          private: true,
                                                        ))));
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.lock_outlined,
                                                color: Color.fromARGB(
                                                    255, 125, 123, 123),
                                                size: 20,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7, 0, 0, 0),
                                                child:
                                                    Text('Add a Private Club',
                                                        style: GoogleFonts.lato(
                                                          color: Colors.black,
                                                        )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.fromLTRB(
                                            width_sc * 0.03,
                                            heigth_sc * 0.02,
                                            0,
                                            heigth_sc * 0.005),
                                        child: const Align(
                                            alignment: Alignment.topLeft,
                                            child: Text('Logout',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16))),
                                      ),
                                      Container(
                                        width: width_sc,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            elevation: 0.0,
                                            shadowColor: Colors.transparent,
                                            tapTargetSize: MaterialTapTargetSize
                                                .shrinkWrap,
                                            primary: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(0)),
                                          ),
                                          onPressed: () {
                                            setState(() async {
                                              await _auth.signOut();
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.logout,
                                                color: Color.fromARGB(
                                                    255, 125, 123, 123),
                                                size: 20,
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        7, 0, 0, 0),
                                                child: Text('Logout',
                                                    style: GoogleFonts.lato(
                                                      color: Colors.black,
                                                    )),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        height: heigth_sc * 0.001,
                                      ),
                                    ],
                                  ))
                            ]));
                      }
                      return const SizedBox.shrink();
                    })),
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
                              color: Colors.black, size: 25))),
                  Container(
                      padding: EdgeInsets.only(right: 16),
                      child: IconButton(
                          onPressed: () {
                            widget.togglePage!(4);
                            widget.toggleLoad;
                          },
                          icon: const Icon(Icons.settings,
                              color: Colors.deepPurple, size: 25)))
                ],
              ),
            ),
          );
  }
}
