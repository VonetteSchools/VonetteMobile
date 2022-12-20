// ignore_for_file: use_build_context_synchronously

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vonette_mobile/screens/authenticate/loginPage.dart';
import 'package:vonette_mobile/services/authentication.dart';



class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final vonetteLogo = 'assets/main_images/vonette_icon.png';
  final googleImage = 'assets/system_images/google_logo.png';

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String error = "";
  String username = "";
  String password = "";
  String passwordConf = "";
  String email = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
            Align(alignment: Alignment.topLeft, child: Padding(padding: const EdgeInsets.only(top: 10, left: 10),child: Image(image: AssetImage(vonetteLogo),height: 60,width: 60,))),
            const Text('Sign up',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            
            const Text('Sign up to view your schools announcements',style: TextStyle(fontSize: 15, color: Colors.black45),textAlign: TextAlign.center,),
            const SizedBox(height: 18),
            
            OutlinedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.white), shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))),
              onPressed: () async {
                dynamic result = await _auth.signInWithGoogle;
                if (result[0] == null) {
                  setState(() {
                    error = result[1];
                  });
                }
              },
              child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.min,children: [
                Image(image: AssetImage(googleImage), height: 27,),
                const Padding(padding: EdgeInsets.only(left: 10), child: Text("Sign In With Google", style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.w600)))
            ],)),
            
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Have an account?', style: TextStyle(fontSize: 15, color: Colors.black45),textAlign: TextAlign.center,),
              const SizedBox(width: 10),
              RichText(text: TextSpan(text: "Login", style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()..onTap = () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const LoginPage()
                  ));
                })),
            ]),
            
            Form(key: _formKey, child: Padding(padding: const EdgeInsets.all(15), child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'User Name',
                    hintText: 'Enter Your Name',
                  ),
                  onChanged: (val) { setState(() => username = val);},
                  validator: (val) => val!.isEmpty ? 'Enter A Username' : null
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                    hintText: 'Enter An Email Address',
                  ),
                  onChanged: (val) { setState(() => email = val);},
                  validator: (val) => val!.isEmpty ? 'Enter An Email' : null
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                    hintText: 'Enter A Password',
                  ),
                  onChanged: (val) { setState(() => password = val);},
                  validator: (val) => val!.isEmpty ? 'Enter A Password' : null
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Confirm Password',
                    hintText: 'Enter Password',
                  ),
                  onChanged: (val) { setState(() => passwordConf = val);},
                  validator: (val) => password != val ? 'Password Doesn\'t Match' : null
                ),
              ),
              const Text('Read our Privacy Policy',style: TextStyle(color: Colors.grey,decoration: TextDecoration.underline)),
              const SizedBox(height: 17),
        
              SizedBox(height: 40, width: 300,child: ElevatedButton(
                child: const Text('Sign In'),
                onPressed: () async {
                  if (email.trim().contains('@apps.nsd.org') || email.trim().contains('@nsd.org')) {
                    if (_formKey.currentState!.validate()) {
                      dynamic result = await _auth.regEmailPass(email.trim(), password, username.trim());
                      if (result[0] != null) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        } else {
                          setState(() {error = result[1] as String;});
                        }
                    }
                  } else {
                    setState(() {error = 'Please use Your School Email!';});
                  }
                }
              ),
              )],
            )),
            ),
            const SizedBox(height: 15.0,),
            Text(error, style: const TextStyle(color: Colors.red, fontSize: 10.0, fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}

