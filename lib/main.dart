// ignore_for_file: depend_on_referenced_packages
import 'package:vonette_mobile/screens/wrapper/wrapper.dart';
import 'package:vonette_mobile/services/authentication.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  //this is a comment

  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserInApp?>.value(
      value: AuthService().user,
      initialData: null,
      child:
          const MaterialApp(debugShowCheckedModeBanner: false, home: Wrapper()),
    );
  }
}
