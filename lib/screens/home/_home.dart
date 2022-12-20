import 'package:vonette_mobile/screens/home/announcements/announcements.dart';
import 'package:vonette_mobile/screens/home/calendar/calendar.dart';
import 'package:vonette_mobile/screens/home/chatApp/chatApp.dart';
import 'package:vonette_mobile/screens/home/settings/settings.dart';
import 'package:flutter/material.dart';
import 'package:vonette_mobile/shared/loading.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {

  // we are adding a loading page where just in case one of redirects
  // doesn't open up quickly, the loading page keeps them busy
  bool loading = false;
  void toggleLoading() {
    setState(() => loading = !loading);
  }

  // showPages helps toggle between settings, chatapp, annouce, home
  // below code should be self explanatory about whats happening
  int showPages = 1;
  void togglePages(int value) {
    setState(() => showPages = value);
  }
  @override
  Widget build(BuildContext context) {
    if (showPages == 1) {
      return loading ? const Loading() : Announcements(togglePage: togglePages, toggleLoad: toggleLoading);
    } else if (showPages == 2) {
      return loading ? const Loading() : ChatApp(togglePage: togglePages, toggleLoad: toggleLoading);
    } else if (showPages == 3) {
      return loading ? const Loading() : Calendar(togglePage: togglePages, toggleLoad: toggleLoading);
    } else {
      return loading ? const Loading() : SettingsPage(togglePage: togglePages, toggleLoad: toggleLoading);
    }
  }
}

