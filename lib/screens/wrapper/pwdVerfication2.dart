// ignore_for_file: depend_on_referenced_packages, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:provider/provider.dart';

class PwdVerification extends StatefulWidget {
  final String clubName;
  const PwdVerification({super.key, required this.clubName});

  @override
  State<PwdVerification> createState() => _PwdVerificationState();
}

class _PwdVerificationState extends State<PwdVerification> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  String error = '';

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);

    final defaultPinTheme = PinTheme(
      width: 60, height: 65,
      textStyle: GoogleFonts.poppins(
          fontSize: 20, color: Colors.black),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final cursor = Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: 20, height: 2, margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(color: Colors.purpleAccent,borderRadius: BorderRadius.circular(8),),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: PreferredSize(preferredSize: Size.fromHeight(heigth_sc*0.10),child: AppBar(
          centerTitle: true,title: const Text("Password Verification"),flexibleSpace: Container(decoration: purpleGradient))),
      
      body: Column(children: [
        const SizedBox(height: 40),
        const Center(child: Text('Verification', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        const SizedBox(height: 40),
        const Center(child: Text('Click The Button To Check The Password')),
        const SizedBox(height: 30),
        Center(child: Text(widget.clubName, style: const TextStyle(color: Colors.black54, fontSize: 15))),

        const SizedBox(height: 60),
        Padding(padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Pinput(length: 6, defaultPinTheme: defaultPinTheme,
            controller: controller, focusNode: focusNode,
            separator: const SizedBox(width: 10),
            focusedPinTheme: defaultPinTheme.copyWith(
              decoration: BoxDecoration(
                color: Colors.purple[50],
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black,blurRadius: 25)],
              ),
            ),
            closeKeyboardWhenCompleted: true,
            showCursor: true,cursor: cursor,
            crossAxisAlignment: CrossAxisAlignment.center,                 
          ),
        ),
        const SizedBox(height: 40),
        const Center(child: Text('Click The Button To Check Password')),
        TextButton(onPressed: (() async {
          var password = await DatabaseService(user: user).getClubPassword(widget.clubName);
          if (controller.text == password) {
            setState(() {
              error = "Successfully Added Into The Private Club!";
            });
            DatabaseService(user: user).updateClubMemberList(widget.clubName);
          } else {
            setState(() {
              error = "Incorrect Password! Try Again";
            });
          }
        }), child: const Text("Check")),
        Center(child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 11.0, fontWeight: FontWeight.bold))),
      ],
    )
    );
  }
}