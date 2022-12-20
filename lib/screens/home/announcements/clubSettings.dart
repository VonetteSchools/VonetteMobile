import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/announcements/setPassword.dart';
import 'package:vonette_mobile/screens/home/settings/editProfile.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ClubSettings extends StatefulWidget {
  String profileUrl;
  String clubName;
  List adminList;
  String? privatePassword;
  bool? isPrivate;
  ClubSettings(
      {super.key,
      required this.profileUrl,
      required this.clubName,
      required this.adminList,
      required this.isPrivate,
      required this.privatePassword});

  // creates background task which states which page is running
  // notice that button runs the toggleView functions from authen.dart that
  // switches between the register and sign in page.
  @override
  State<ClubSettings> createState() => _ClubSettingsState();
}

class _ClubSettingsState extends State<ClubSettings> {
  Color c1 = const Color(0xF6F6F6);
  String newClubTitle = "";
  String newClubDesc = "";

  @override
  Widget build(BuildContext context) {
    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);

    Future uploadProfilePicture() async {
      UploadTask? uploadTask;
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return null;

      final path = 'ClubProfilePhotos/${result.files.first.name}';
      final file = File(result.files.first.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      setState(() {
        widget.profileUrl = urlDownload;
        DatabaseService(user: user)
            .addClubProfileImageUrl(widget.profileUrl, widget.clubName);
      });
    }
    
    return Scaffold(
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: DatabaseService(user: user).updateClubSnapshot,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Container(
                          height: heigth_sc * 0.280,
                          width: width_sc,
                          color: Colors.white,
                          child: Column(children: [
                            SizedBox(height: heigth_sc * 0.09),
                            Stack(children: [
                              CircleAvatar(
                                  radius: 30,
                                  backgroundImage:
                                      NetworkImage(widget.profileUrl)),
                            ]),
                            const SizedBox(height: 10),
                            Text(widget.clubName,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 21)),
                            SizedBox(height: 5),
                            Container(
                              width: width_sc * 0.335,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color.fromARGB(255, 144, 98, 224),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(0)),
                                ),
                                onPressed: () {
                                  uploadProfilePicture();
                                },
                                child: const Text('Edit Profile'),
                              ),
                            )
                          ])),
                      Container(
                          width: width_sc,
                          height: heigth_sc * 0.7,
                          color: c1,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    width_sc * 0.03,
                                    heigth_sc * 0.015,
                                    0,
                                    heigth_sc * 0.005),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Manage Members',
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.people,
                                        color: Color.fromARGB(
                                            255, 125, 123, 123),
                                        size: 20,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(7, 0, 0, 0),
                                        child: Text('Admins',
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
                                width: width_sc,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    shadowColor: Colors.transparent,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.report_problem_outlined,
                                        color: Color.fromARGB(
                                            255, 125, 123, 123),
                                        size: 20,
                                      ),
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(7, 0, 0, 0),
                                        child: Text('Report a Bug/User',
                                            style: GoogleFonts.lato(
                                              color: Colors.black,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              //Size between two containers
                              SizedBox(
                                height: heigth_sc * 0.001,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    width_sc * 0.03,
                                    heigth_sc * 0.03,
                                    0,
                                    heigth_sc * 0.005),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Club Access',
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
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                            'Current Status: ${widget.isPrivate! ? "Private" : "Public"}',
                                            style: GoogleFonts.lato(
                                              color: Colors.black,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: width_sc,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0.0,
                                    shadowColor: Colors.transparent,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    primary: Colors.white,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(0)),
                                  ),
                                  onPressed: () {},
                                  child: Row(
                                    children: [
                                      Container(
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        child: Text(
                                            'Club Access Code: ${widget.privatePassword}',
                                            style: GoogleFonts.lato(
                                              color: Colors.black,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              
                              SizedBox(
                                height: heigth_sc * 0.02,
                              ),
                              Container(
                                      padding: EdgeInsets.fromLTRB(
                                          0, 0, width_sc * 0.2, 0),
                                      child: Text(
                                        'Do you want to make you club Public or Private?',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: heigth_sc * 0.0075),
                                    Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              width_sc * 0.032, 0, 0, 0),
                                          child: Icon(
                                            Icons.info_rounded,
                                            color: Color.fromARGB(
                                                255, 125, 123, 123),
                                            size: 17,
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              width_sc * 0.0125, 0, 0, 0),
                                          child: Text(
                                              'If you make your club private, users will need an access code to join the club.',
                                              style: TextStyle(
                                                fontSize: 10,
                                              )),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                height: heigth_sc * 0.01,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: width_sc * 0.275),
                                  Container(
                                    height: heigth_sc * 0.035,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                        onPressed: () {
                                          DatabaseService(user: user).updatePrivateOption(false, widget.clubName);
                                          DatabaseService(user: user).updatePasswordForPrivate("", widget.clubName);
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          'Public',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        )),
                                  ),
                                  SizedBox(width: width_sc * 0.1),
                                  Container(
                                    height: heigth_sc * 0.035,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: ((context) => SetPassword(clubName: widget.clubName))));
                                        },
                                        child: Text(
                                          'Private',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12),
                                        )),
                                  ),
                                ],
                              ),
                              // Container(
                              //   height: heigth_sc * 0.09,
                              //   child: Padding(
                              //     padding: EdgeInsets.all(15),
                              //     child: TextFormField(
                              //       obscureText: false,
                              //       decoration: InputDecoration(
                              //         border: OutlineInputBorder(),
                              //         labelText: 'Change Club Title',
                              //         hintText: 'Change Club Title',
                              //       ),
                              //       onChanged: (value) => setState(() {
                              //         newClubTitle = value;
                              //       }),
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: heigth_sc * 0.001,
                              ),
                              Container(
                                padding: EdgeInsets.fromLTRB(
                                    width_sc * 0.03,
                                    heigth_sc * 0.03,
                                    0,
                                    heigth_sc * 0.005),
                                child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Text('Edit Club Info',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16))),
                              ),
                              Container(
                                height: heigth_sc * 0.09,
                                child: Padding(
                                  padding:
                                      EdgeInsets.fromLTRB(
                                                15, 5, 15, 0),
                                  child: TextFormField(
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Change Club Description',
                                      hintText: 'Change Club Desciption',
                                    ),
                                    onChanged: (value) => setState(() {
                                      newClubDesc = value;
                                    }),
                                  ),
                                ),
                              ),
                              Container(
                              width: width_sc * 0.335,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary:
                                      Color.fromARGB(255, 144, 98, 224),
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(0)),
                                ),
                                onPressed: () async {
                                  // if(newClubTitle.isNotEmpty) {
                                  //   await DatabaseService(user: user).updateClubTitle(newClubTitle, widget.clubName);
                                  //   Navigator.of(context).pop();
                                  // }
                                  if(newClubDesc.isNotEmpty) {
                                    await DatabaseService(user: user).updateClubDesc(newClubDesc, widget.clubName);
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: const Text('Save'),
                              ))
                              
                            ],
                          ))
                    ],
                  );
                }
                return const Loading();
              })),
    floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () {
                Navigator.of(context).pop();
              },backgroundColor: Colors.deepPurple,child: const Icon(Icons.arrow_back)),);
  }
}
