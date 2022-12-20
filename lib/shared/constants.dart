import 'package:flutter/material.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/database.dart';

// ignore: non_constant_identifier_names
final FormFieldDecoration = InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.black26, width: 1.0),
      borderRadius: BorderRadius.circular(50)),
  focusedBorder: OutlineInputBorder(
      borderSide: const BorderSide(color: Colors.deepOrange, width: 1.0),
      borderRadius: BorderRadius.circular(50)),
  hintStyle: const TextStyle(fontSize: 13, color: Colors.black54),
  prefixIconConstraints: const BoxConstraints(minWidth: 40, maxHeight: 20),
  isDense: true,
  contentPadding: const EdgeInsets.all(8),
  errorStyle: const TextStyle(fontSize: 7),
);

// General
const barColor = Colors.white;
const purpleBarColor = Colors.deepPurple;
const backgroundColor = Colors.white;
const accentPurple = Color.fromARGB(255, 144, 98, 224);
const headingTextColor = Colors.black;
const headingIconColor = Colors.black;
const inksplashColor = Colors.grey;

// Chat app
const messageFriendColor = Color.fromARGB(255, 221, 221, 221);
const messageMeColor = Color.fromARGB(255, 144, 98, 224);
const textFriendColor = Colors.black;
const textMeColor = Colors.white;
const textFieldFocusColor = Color.fromARGB(255, 96, 96, 96);
const textFieldDisabledColor = Color.fromARGB(255, 96, 96, 96);

const purpleGradient = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.deepPurple, Colors.purple]));

const purpleAccentGradient = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.deepPurpleAccent, Colors.purpleAccent]));

const meGradient = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Colors.deepPurple, Colors.purple]));

const friendGradient = BoxDecoration(
    borderRadius: BorderRadius.all(Radius.circular(12)),
    color: Color.fromARGB(255, 226, 226, 226));

Widget searchBar(width_sc, heigth_sc, TextEditingController? controller) {
  return Container(
    width: width_sc * 0.75,
    decoration: const BoxDecoration(boxShadow: [
      BoxShadow(
          blurStyle: BlurStyle.outer, blurRadius: 10, color: Colors.black45)
    ], borderRadius: BorderRadius.all(Radius.circular(50))),
    child: TextField(
      style: const TextStyle(color: Colors.white),
      controller: controller,
      decoration: InputDecoration(
        hintText: 'Search...',
        hintStyle: const TextStyle(color: Colors.white),
        isDense: true,
        isCollapsed: true,
        contentPadding: EdgeInsets.only(
            top: heigth_sc * 0.015, bottom: heigth_sc * 0.015, left: 25),
        focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(50)),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.transparent, width: 1),
          borderRadius: BorderRadius.circular(50),
        ),
      ),
    ),
  );
}

Widget newSearchBar(width_sc, heigth_sc, TextEditingController controller,
    List stringList, ScrollController scrollController) {
  return Container(
    width: width_sc * 0.75,
    decoration: const BoxDecoration(boxShadow: [
      BoxShadow(
          blurStyle: BlurStyle.outer, blurRadius: 10, color: Colors.black45)
    ], borderRadius: BorderRadius.all(Radius.circular(50))),
    child: TextFieldSearch(
        label: 'SearchFeature',
        initialList: stringList,
        controller: controller,
        scrollbarDecoration: ScrollbarDecoration(
            theme: ScrollbarThemeData(
                thumbColor: MaterialStateProperty.all(Colors.purpleAccent),
                thickness: MaterialStateProperty.all(5),
                thumbVisibility: MaterialStateProperty.all(true),
                interactive: true,
                radius: const Radius.circular(100),
                minThumbLength: 3),
            controller: scrollController),
        minStringLength: 1,
        textStyle: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: const TextStyle(color: Colors.white),
            isDense: true,
            isCollapsed: true,
            contentPadding: EdgeInsets.only(
                top: heigth_sc * 0.015, bottom: heigth_sc * 0.015, left: 25),
            focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(50)),
            enabledBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Colors.transparent, width: 1),
                borderRadius: BorderRadius.circular(50)))),
  );
}
