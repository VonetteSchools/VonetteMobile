// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/authentication.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  final Function? togglePage;
  final Function? toggleLoad;
  const EditProfile({this.togglePage, this.toggleLoad});

  // creates background task which states which page is running
  // notice that button runs the toggleView functions from authen.dart that
  // switches between the register and sign in page.
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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

    void clearText() {
      fieldTextController.clear();
      fieldTextController2.clear();
    }

    Future uploadProfilePicture() async {
      UploadTask? uploadTask;
      final result = await FilePicker.platform.pickFiles();
      if (result == null) return;

      final path = 'ProfilePhotos/${result.files.first.name}';
      final file = File(result.files.first.path!);
      final ref = FirebaseStorage.instance.ref().child(path);
      uploadTask = ref.putFile(file);

      final snapshot = await uploadTask.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      DatabaseService(user: user).addProfileImageUrl(urlDownload);
    }

    int selectedValue = 1;
    return Scaffold(
      body: SingleChildScrollView(
          child: StreamBuilder(
              stream: DatabaseService(user: user).getCurrentUserDM,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  var name = snapshot.data['username'];
                  var email = snapshot.data['email'];
                  var counsellor = snapshot.data['counsellor'];
                  var imageUrl = snapshot.data['profile_url'];

                  return Form(
                      key: _formKey,
                      child: Column(children: [
                        Container(
                            height: heigth_sc * 0.31,
                            width: width_sc,
                            color: Colors.white,
                            child: Column(children: [
                              const SizedBox(height: 60),
                              Stack(
                                children: [
                                  CircleAvatar(
                                      radius: 30,
                                      backgroundImage: NetworkImage(imageUrl)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text('$name',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21)),
                              const SizedBox(height: 5),
                              Text('$email'),
                              const SizedBox(height: 5),
                              SizedBox(
                                width: width_sc * 0.335,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary:
                                        const Color.fromARGB(255, 144, 98, 224),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(0)),
                                  ),
                                  onPressed: () {
                                    uploadProfilePicture();
                                  },
                                  child: const Text(
                                    'Edit Profile Picture',
                                    style: TextStyle(fontSize: 11.5),
                                  ),
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
                                  padding: EdgeInsets.fromLTRB(width_sc * 0.065,
                                      heigth_sc * 0.03, 0, heigth_sc * 0.005),
                                  child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Username',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      width_sc * 0.025, 0, heigth_sc * 0.01, 0),
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
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('$name',
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                              )),
                                        ),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('Edit',
                                                style: GoogleFonts.lato(
                                                  color: accentPurple,
                                                  fontSize: 13,
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: heigth_sc * 0.005),
                                Container(
                                  padding: EdgeInsets.fromLTRB(width_sc * 0.065,
                                      heigth_sc * 0.03, 0, heigth_sc * 0.005),
                                  child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Email Address',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      width_sc * 0.025, 0, heigth_sc * 0.01, 0),
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
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('$email',
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                              )),
                                        ),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('Edit',
                                                style: GoogleFonts.lato(
                                                  color: accentPurple,
                                                  fontSize: 13,
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: heigth_sc * 0.005),
                                Container(
                                  padding: EdgeInsets.fromLTRB(width_sc * 0.065,
                                      heigth_sc * 0.03, 0, heigth_sc * 0.005),
                                  child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Counselor',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      width_sc * 0.025, 0, heigth_sc * 0.01, 0),
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
                                    child: Stack(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          child: Text('$counsellor',
                                              style: GoogleFonts.lato(
                                                color: Colors.black,
                                              )),
                                        ),
                                        Container(
                                            alignment: Alignment.centerRight,
                                            child: Text('Edit',
                                                style: GoogleFonts.lato(
                                                  color: accentPurple,
                                                  fontSize: 13,
                                                )))
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(width_sc * 0.03,
                                      heigth_sc * 0.02, 0, heigth_sc * 0.005),
                                  child: const Align(
                                      alignment: Alignment.topLeft,
                                      child: Text('Password',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16))),
                                ),
                                Container(
                                    color: Colors.white,
                                    height: heigth_sc * 0.23,
                                    width: width_sc * 0.95,
                                    child: Column(children: [
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 0,
                                              left: 5,
                                              right: 70),
                                          child: SizedBox(
                                              height: heigth_sc * 0.045,
                                              width: width_sc * 0.8,
                                              child: TextFormField(
                                                  controller:
                                                      fieldTextController,
                                                  decoration:
                                                      const InputDecoration(
                                                          border:
                                                              OutlineInputBorder(),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .deepOrange,
                                                                width: 1.0),
                                                          ),
                                                          labelText:
                                                              'Change Password',
                                                          floatingLabelStyle:
                                                              TextStyle(
                                                                  color: Colors
                                                                      .deepOrange)),
                                                  obscureText: true,
                                                  validator: (val) =>
                                                      val!.isEmpty
                                                          ? 'Enter Password'
                                                          : null,
                                                  onChanged: (val) {
                                                    setState(
                                                        () => password = val);
                                                  }))),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10,
                                              bottom: 0,
                                              left: 5,
                                              right: 70),
                                          child: SizedBox(
                                            height: heigth_sc * 0.045,
                                            width: width_sc * 0.8,
                                            child: TextFormField(
                                                controller:
                                                    fieldTextController2,
                                                decoration: const InputDecoration(
                                                    border:
                                                        OutlineInputBorder(),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                                color: Colors
                                                                    .deepOrange,
                                                                width: 1.0)),
                                                    labelText:
                                                        'Confirm Password',
                                                    floatingLabelStyle:
                                                        TextStyle(
                                                            color: Colors
                                                                .deepOrange)),
                                                obscureText: true,
                                                validator: (val) => val!.isEmpty
                                                    ? 'Confirm Password'
                                                    : null,
                                                onChanged: (val) {
                                                  setState(() =>
                                                      conf_password = val);
                                                }),
                                          )),
                                      Container(
                                          height: heigth_sc * 0.06,
                                          width: width_sc * 0.335,
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 15, 10, 0),
                                          child: Ink(
                                              decoration: purpleAccentGradient,
                                              child: ElevatedButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      if (password ==
                                                          conf_password) {
                                                        if (password.length >=
                                                            6) {
                                                          setState(() {
                                                            loading = false;
                                                          });
                                                          dynamic result =
                                                              await _auth
                                                                  .updateUserPassword(
                                                                      password);
                                                          if (result[0] ==
                                                              null) {
                                                            setState(() {
                                                              error = result[1]
                                                                  as String;
                                                              loading = false;
                                                            });
                                                          } else if (result[
                                                                  0] !=
                                                              null) {
                                                            setState(() {
                                                              loading = false;
                                                              fieldTextController
                                                                  .clear();
                                                              fieldTextController2
                                                                  .clear();
                                                              error =
                                                                  "Your Password Updated!";
                                                            });
                                                          }
                                                        } else {
                                                          setState(() {
                                                            error =
                                                                'Password Should Be Longer Than 6 Characters!';
                                                          });
                                                        }
                                                      } else {
                                                        setState(() {
                                                          error =
                                                              'Both Passwords Don\'t Match!';
                                                        });
                                                      }
                                                    }
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                      primary:
                                                          const Color.fromARGB(
                                                              255,
                                                              144,
                                                              98,
                                                              224),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          0))),
                                                  child: const Text('Save',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ))))),
                                      const SizedBox(height: 5),
                                      Text(error,
                                          style: const TextStyle(
                                              color: Colors.red,
                                              fontSize: 10.0,
                                              fontWeight: FontWeight.bold)),
                                    ])),
                                SizedBox(height: heigth_sc * 0.01),
                                Container(
                                  padding: EdgeInsets.fromLTRB(
                                      0, 0, width_sc * 0.58, 0),
                                  child: Text(
                                    'Read our Privacy Policy',
                                    style: GoogleFonts.lato(
                                      decoration: TextDecoration.underline,
                                      color: Colors.black,
                                      fontSize: 11,
                                    ),
                                  ),
                                )
                              ],
                            )),
                      ]));
                }
                return const LinearProgressIndicator();
              })),
      floatingActionButton: FloatingActionButton(
          mini: true,
          onPressed: () {
            Navigator.of(context).pop();
          },
          backgroundColor: Colors.deepPurple,
          child: const Icon(Icons.arrow_back)),
    );
  }
}
