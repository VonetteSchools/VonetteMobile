import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:vonette_mobile/screens/authenticate/loginPage.dart';
import 'package:vonette_mobile/screens/authenticate/signInPage.dart';
import 'package:vonette_mobile/services/authentication.dart';

class MainUserPage extends StatefulWidget {
  const MainUserPage({super.key});

  @override
  State<MainUserPage> createState() => _MainUserPageState();
}

class _MainUserPageState extends State<MainUserPage> {
  final vonetteLogo = 'assets/main_images/vonette_icon.png';
  final purpleImage = 'assets/system_images/purple_login_logo.png';
  final googleImage = 'assets/system_images/google_logo.png';
  final messagingImage = 'assets/system_images/new_messages_image.JPG';
  final calendarImage = 'assets/system_images/calendar_image.JPG';
  final securityImage = 'assets/system_images/security_image.JPG';

  final AuthService _auth = AuthService();
  String error = "";
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        body: Column(children: [
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
            'Welcome to Vonette',
            style: TextStyle(fontSize: 25),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          const Text(
            'Please log or sign up to continue using our app.',
            style: TextStyle(fontSize: 15, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: 20,
          ),
          Align(
              alignment: Alignment.center,
              child: Image(
                image: AssetImage(purpleImage),
              )),
          const SizedBox(height: 20),
          const Text(
            'Sign up to see what you\'re missing!',
            style: TextStyle(fontSize: 15, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SizedBox(
              height: 40,
              width: 300,
              child: OutlinedButton(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40)))),
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
                      Image(
                        image: AssetImage(googleImage),
                        height: 27,
                      ),
                      const Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text("Sign In With Google",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                  fontWeight: FontWeight.w600)))
                    ],
                  ))),
          const SizedBox(height: 10),
          RichText(
              text: TextSpan(
                  text: "or Sign Up with School Email",
                  style: const TextStyle(
                      color: Colors.grey, decoration: TextDecoration.underline),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignInPage()));
                    })),
          const SizedBox(height: 5),
          Text(error,
              style: const TextStyle(
                  fontSize: 15,
                  color: Colors.red,
                  decoration: TextDecoration.underline),
              textAlign: TextAlign.center),
          SizedBox(
            height: 220,
            child: CarouselSlider(
                options: CarouselOptions(
                  height: 160.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: [
                  Card(
                    elevation: 5,
                    child: Row(children: [
                      Image(
                          image: AssetImage(messagingImage),
                          width: 100,
                          height: 100),
                      const SizedBox(width: 5),
                      SizedBox(
                          height: 100,
                          width: 190,
                          child: Column(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Text(
                                    'Direct Messaging',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  )),
                              Text(
                                  'Vonette helps you get in touch with anyone from your club and meet new people!'),
                            ],
                          ))
                    ]),
                  ),
                  Card(
                    elevation: 10,
                    child: Row(children: [
                      Padding(
                          padding: EdgeInsets.fromLTRB(10, 0, 5, 0),
                          child: Image(
                              image: AssetImage(calendarImage),
                              width: 75,
                              height: 75)),
                      const SizedBox(width: 5),
                      SizedBox(
                          height: 100,
                          width: 200,
                          child: Column(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Text(
                                    'Plan Your Events & Meetings',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  )),
                              Text(
                                  'Add club meetings and study sessions to the Vonette\'s calendar to get ahead of the school year!'),
                            ],
                          ))
                    ]),
                  ),
                  Card(
                    elevation: 10,
                    child: Row(children: [
                      Image(
                          image: AssetImage(securityImage),
                          width: 100,
                          height: 100),
                      const SizedBox(width: 5),
                      SizedBox(
                          height: 100,
                          width: 190,
                          child: Column(
                            children: const [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  child: Text(
                                    'Safety & Security',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  )),
                              Text(
                                  'Our aim is to provide user safety hence the option to report other users and bugs to enhance experience.'),
                            ],
                          ))
                    ]),
                  )
                ]),
          ),
          const Text(
            'Have an account?',
            style: TextStyle(fontSize: 15, color: Colors.black45),
            textAlign: TextAlign.center,
          ),
          RichText(
              text: TextSpan(
                  text: "Login",
                  style: const TextStyle(color: Colors.blue),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    })),
        ]),
      ),
    );
  }
}
