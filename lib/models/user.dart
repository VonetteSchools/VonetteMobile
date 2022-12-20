// the UserInApp class basically removes all the unneccessary information
// given defaultly by the firebase app and restricts just the uid cuz thats imp
class UserInApp {
  final String uid;
  final String? email;
  final String? username;

  UserInApp({
    required this.uid,
    required this.email,
    required this.username,
  });
}
