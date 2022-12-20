// ignore_for_file: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:email_auth/email_auth.dart';

class OTPView extends StatefulWidget {
  String advEmail;
  String clubName;
  String clubDesc;
  String imageUrl;
  bool private;
  String privateKey;
  OTPView({super.key, required this.advEmail, required this.clubName, 
    required this.clubDesc, required this.imageUrl, required this.private,
    required this.privateKey});

  @override
  State<OTPView> createState() => _OTPViewState();
}

class _OTPViewState extends State<OTPView> {
  final controller = TextEditingController();
  final focusNode = FocusNode();
  late EmailAuth emailAuth =  EmailAuth(sessionName: widget.clubName);
  String error = '';

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void sendOTP() async {
    bool result = await emailAuth.sendOtp(
      recipientMail: widget.advEmail);
    if (result) {
      print("Sent Success");
    }
  }

  void verifyOTP(String userOTP, String club_name, String club_desc,
    String adv_addr, String imageUrl, bool private, String privateKey, UserInApp? user) {
    bool result = emailAuth.validateOtp(recipientMail: widget.advEmail,userOtp: userOTP);
    if (result) {
      DatabaseService(user: user).addClubInformation(club_name, club_desc, adv_addr, private, privateKey);
      DatabaseService(user: user).addClubProfileImageUrl(imageUrl, club_name);
      DatabaseService(user: user).updateClubAdminList(club_name);
      Navigator.of(context).popUntil((route) => route.isFirst);
      setState(() => error = 'Successfully Created Club');
    } else {
      setState(() => error = 'Invalid OTP!');
    }
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
      textStyle: GoogleFonts.poppins(fontSize: 20, color: Colors.black),
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
          centerTitle: true,title: const Text("OTP Verification"),flexibleSpace: Container(decoration: purpleGradient))),
      
      body: Column(children: [
        const SizedBox(height: 40),
        const Center(child: Text('Verification', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold))),
        const SizedBox(height: 40),
        const Center(child: Text('Click The Button To Send OTP To Advisors Email')),
        const SizedBox(height: 30),
        Center(child: Text(widget.advEmail, style: const TextStyle(color: Colors.black54, fontSize: 15))),

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
            onCompleted: (value) => verifyOTP(value, widget.clubName, widget.clubDesc, widget.advEmail, 
              widget.imageUrl, widget.private, widget.privateKey, user),                  
          ),
        ),
        const SizedBox(height: 40),
        const Center(child: Text('Click The Button To Send The OTP')),
        TextButton(onPressed: (() => sendOTP()), child: const Text("Send")),
        Center(child: Text(error, style: const TextStyle(color: Colors.red, fontSize: 11.0, fontWeight: FontWeight.bold))),
      ],
    )
    );
  }
}