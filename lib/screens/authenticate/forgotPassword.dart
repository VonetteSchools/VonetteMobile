import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vonette_mobile/screens/authenticate/loginPage.dart';
import 'package:vonette_mobile/services/authentication.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => ForgotPasswordState();
}

class ForgotPasswordState extends State<ForgotPassword> {
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
            Align(
                alignment: Alignment.topLeft,
                child: Padding(
                    padding: const EdgeInsets.only(top: 10, left: 10),
                    child: Image(
                      image: AssetImage(vonetteLogo),
                      height: 60,
                      width: 60,
                    ))),
            const Text(
              'Forgot Password',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            const Text(
              'No worries, send a link to reset your password',
              style: TextStyle(fontSize: 15, color: Colors.black45),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Go Back',
                  style: TextStyle(
                      fontSize: 15,
                      color: Colors.black45,
                      decoration: TextDecoration.underline),
                  textAlign: TextAlign.center,
                ),
              )
            ]),
            Form(
              key: _formKey,
              child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Email Address',
                              hintText: 'Enter Your Email Address',
                            ),
                            onChanged: (val) {
                              setState(() => email = val);
                            },
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty ? 'Enter A Email Address' : null),
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
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            textInputAction: TextInputAction.next,
                            validator: (val) =>
                                val!.isEmpty ? 'Enter A Password' : null),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: TextFormField(
                            obscureText: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Confirm New Password',
                              hintText: 'Confirm New Password',
                            ),
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                            validator: (val) =>
                                val!.isEmpty ? 'Confirm New Password' : null),
                      ),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: const Text('Log In',
                              style: TextStyle(
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline))),
                      const SizedBox(height: 17),
                      SizedBox(
                        height: 40,
                        width: 300,
                        child: ElevatedButton(
                          child: const Text('Send Password Reset Link'),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              dynamic result = await _auth.signInEmailPass(
                                  email.trim(), password);
                              if (result[0] != null) {
                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                              } else {
                                setState(() {
                                  error = result[1] as String;
                                });
                              }
                            }
                          },
                        ),
                      )
                    ],
                  )),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(error,
                style: const TextStyle(
                    color: Colors.red,
                    fontSize: 10.0,
                    fontWeight: FontWeight.bold)),
          ]),
        ),
      ),
    );
  }
}