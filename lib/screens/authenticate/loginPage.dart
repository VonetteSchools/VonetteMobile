// ignore_for_file: use_build_context_synchronously
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vonette_mobile/screens/authenticate/signInPage.dart';
import 'package:vonette_mobile/services/authentication.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final vonetteLogo = 'assets/main_images/vonette_icon.png';
  final googleLogo = 'assets/system_images/google_logo.png';

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String error = "";
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
            Align(alignment: Alignment.topLeft, child: Padding(padding: const EdgeInsets.only(top: 10, left: 10),child: Image(image: AssetImage(vonetteLogo),height: 60,width: 60,))),
            const Text('Login Now',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
            const SizedBox(height: 10),
            
            const Text('Please login to continue using our app',style: TextStyle(fontSize: 15, color: Colors.black45),textAlign: TextAlign.center,),
            const SizedBox(height: 18),
            
            OutlinedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)))),
                onPressed: () async {
                  dynamic result = await _auth.signInWithGoogle;
                    if (result[0] == null) {
                      setState(() {
                        error = result[1];
                      });
                    }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(image: AssetImage(googleLogo),height: 20,width: 20,),
                    const Padding(padding: EdgeInsets.only(left: 10),child: Text("Sign In With Google",style: TextStyle(fontSize: 14,color: Colors.black54,fontWeight: FontWeight.w600)))
                  ],
                )),

            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              const Text('Don\'t have an account?',style: TextStyle(fontSize: 15, color: Colors.black45),textAlign: TextAlign.center,),
              const SizedBox(width: 10),
              
              RichText(text: TextSpan(text: "SignUp", style: const TextStyle(color: Colors.blue),
                recognizer: TapGestureRecognizer()..onTap = () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const SignInPage()
                  ));
                })),
            ]),
            Form(key: _formKey, child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email Address',
                      hintText: 'Enter Your Email Address',
                    ),
                    onChanged: (val) { setState(() => email = val);},
                    validator: (val) => val!.isEmpty ? 'Enter A Email Address' : null
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: TextFormField(
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                      hintText: 'Enter Password',
                    ),
                    onChanged: (val) { setState(() => password = val);},
                    validator: (val) => val!.isEmpty ? 'Enter A Password' : null
                  ),
                ),
                      
                
                const SizedBox(height: 17),
                SizedBox(height: 40,width: 300,child: ElevatedButton(child: const Text('Login'),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        dynamic result = await _auth.signInEmailPass(email.trim(), password);
                        if (result[0] != null) {
                          Navigator.of(context).popUntil((route) => route.isFirst);
                        } else {
                          setState(() {error = result[1] as String;});
                        }
                      }
                    },
                  ),
                )
              ],
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