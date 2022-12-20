// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/authenticate/mainUserPage.dart';
import 'package:vonette_mobile/screens/home/_home.dart';
import 'package:vonette_mobile/screens/wrapper/clubsClass.dart';
import 'package:vonette_mobile/screens/wrapper/counsellor.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vonette_mobile/shared/loading.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  // return either home or authenticate widget
  // looks for the status of auth stream (null or obj)

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserInApp?>(context);
    if (user == null) {
      return const MainUserPage();
    } else {
      // everytime the data changes, the value list
      // or the code is automatically updated with the newer data
      return StreamProvider<QuerySnapshot?>.value(
          initialData: null,
          value: DatabaseService(user: user).updateUserStream,

          //the stream builder looks for if counsellor is none
          // if it is, then its gonna run the counsellors page
          child: StreamBuilder(
            stream: DatabaseService(user: user).getCurrentUserDM,
            builder: ((context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                try {
                  if (snapshot.data['counsellor'] == 'Counsellor: None') 
                    { return const CounselorPage();
                  } else if (snapshot.data['successful'] == false)
                    { return const ClubsClasses();
                    } return const Home();
                } catch(e) { return const Loading();}
              } return const Loading();
            })
          )
        );
    }
  }
}
// change the wrapper thingy to home because home should control all the
// subcategories that the user will have access to.
