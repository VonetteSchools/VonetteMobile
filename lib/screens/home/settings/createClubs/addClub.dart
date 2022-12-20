import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/settings/createClubs/verification.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/loading.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddClub extends StatefulWidget {
  bool private;
  AddClub({super.key, required this.private});
  @override
  State<AddClub> createState() => _AddClubState();
}

class _AddClubState extends State<AddClub> {
  final _formKey = GlobalKey<FormState>();

  String imageClubUrl = "https://tinyurl.com/2p8cdr9d";
  String clubName = '';
  String clubDesc = '';
  String advEmail = '';
  String privateKey = "";
  @override
  Widget build(BuildContext context) {
    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);

    final defaultPinTheme = PinTheme(
      width: width_sc * 0.1,
      height: heigth_sc * 0.05,
      textStyle: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 234, 234, 234),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container( width: 20, height: 2,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.purpleAccent,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );

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
        imageClubUrl = urlDownload;
      });
    }
    return Scaffold(
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: DatabaseService(user: user).getCurrentUserDM,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                var name = snapshot.data['username'];
                var email = snapshot.data['email'];
                var profileUrl = snapshot.data['profile_url'];
                return Form(key: _formKey,
                    child: Column(children: [
                      Container(height: heigth_sc * 0.25, width: width_sc, color: Colors.white,
                          child: Column(children: [
                            const SizedBox(height: 60),
                            CircleAvatar(radius: 30,backgroundImage: NetworkImage(profileUrl)),

                            const SizedBox(height: 10),
                            Text('$name',style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 21)),
                            const SizedBox(height: 5),
                            Text('$email'),
                          ])),

                      Container(width: width_sc,height: heigth_sc * 0.7,color: const Color(0xF6F6F6),
                        child: Column(children: [
                            Row(children: [
                              Container( 
                                padding: EdgeInsets.fromLTRB(width_sc * 0.045, heigth_sc * 0.02,0,heigth_sc * 0.005),
                                child: const Align(alignment: Alignment.topLeft, child: Text('Edit Profile', style: TextStyle(fontWeight:FontWeight.bold,fontSize: 16)))),
                              Container(
                                padding: EdgeInsets.fromLTRB(width_sc * 0.1,heigth_sc * 0.01,0,0),
                                height: heigth_sc * 0.04,
                                child: ElevatedButton(style: ElevatedButton.styleFrom(
                                    primary: const Color.fromARGB(255, 144, 98, 224),
                                    shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(0)),
                                  ),
                                  onPressed: () {
                                    uploadProfilePicture();
                                  },
                                  child: const Text('Select Profile Pic',style: TextStyle(fontSize: 11.5)),
                                ))
                              ],
                            ),
                            SizedBox(height: heigth_sc * 0.015),
                            SizedBox(height: heigth_sc * 0.045,width: width_sc * 0.92,
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,width: 1.0)),
                                    labelText: 'Club Name',
                                    floatingLabelStyle: TextStyle(color: Colors.deepOrange)),
                                  validator: (val) => val!.isEmpty ? 'Enter Club Name' : null,
                                  onChanged: (val) { setState(() => clubName = val); }),
                            ),
                            SizedBox(height: heigth_sc * 0.02),
                            SizedBox(height: heigth_sc * 0.045, width: width_sc * 0.92,
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,width: 1.0)),
                                    labelText: 'Club Description',
                                    floatingLabelStyle: TextStyle(color: Colors.deepOrange,)),
                                  validator: (val) => val!.isEmpty ? 'Enter Club Description' : null,
                                  onChanged: (val) {setState(() => clubDesc = val);}),
                            ),
                            SizedBox(height: heigth_sc * 0.02),
                            SizedBox(height: heigth_sc * 0.045, width: width_sc * 0.92,
                              child: TextFormField(
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.deepOrange,width: 1.0)),
                                    labelText: 'Advisor Email Address',
                                    floatingLabelStyle: TextStyle( color: Colors.deepOrange)),
                                  validator: (val) => val!.isEmpty ? 'Enter Password' : null,
                                  onChanged: (val) {setState(() => advEmail = val);}),
                            ),
                            if (widget.private) ...[
                              SizedBox(height: heigth_sc * 0.03),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, width_sc * 0.485, 0),
                                child: const Text('Create a 6 Digit Access Code',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 13,)),
                              ),
                              SizedBox(height: heigth_sc * 0.01),
                              Container(
                                padding: EdgeInsets.fromLTRB(0, 0, width_sc * 0.0525, 0),
                                child: const Text('This is the code users will need to use to join your club upon search and add.',style: TextStyle(fontSize: 10,)),
                              ),
                              SizedBox(height: heigth_sc * 0.015),
                              Pinput(
                                length: 6,
                                defaultPinTheme: defaultPinTheme,
                                separator: const SizedBox(width: 10),
                                focusedPinTheme: defaultPinTheme.copyWith(
                                  decoration: BoxDecoration(
                                    color: Colors.purple[50],
                                    borderRadius:BorderRadius.circular(8),
                                    boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 25)],
                                  ),
                                ),
                                closeKeyboardWhenCompleted: true,
                                showCursor: true,
                                cursor: cursor,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                onChanged: (value) => privateKey = value,
                              ),
                            ],
                            SizedBox(height: heigth_sc * 0.02),
                            SizedBox(width: width_sc * 0.335,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color.fromARGB(255, 144, 98, 224),
                                  shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(0)),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    Navigator.push(context, MaterialPageRoute(builder: ((context) => OTPView(advEmail: advEmail.trim(), clubName: clubName, clubDesc: clubDesc,  
                                      imageUrl: imageClubUrl, private: widget.private, privateKey: privateKey,))));
                                  }
                                },
                                child: const Text('Send Request',style: TextStyle(fontSize: 11.5)),
                              ),
                            )
                          ],
                        ),
                      ),
                    ]));
              }
              return const Loading();
            })),
            floatingActionButton: FloatingActionButton(
              mini: true,
              onPressed: () {
                Navigator.of(context).pop();
              },backgroundColor: Colors.deepPurple,child: const Icon(Icons.arrow_back)),
    );
  }
}
