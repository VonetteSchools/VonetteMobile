// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/chatApp/chatScreen.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:intl/intl.dart';

class ChatApp extends StatefulWidget {
  final Function? togglePage;
  final Function? toggleLoad;
  const ChatApp({this.togglePage, this.toggleLoad});

  // creates background task which states which page is running
  // notice that button runs the toggleView functions from authen.dart that
  // switches between the register and sign in page.
  @override
  State<ChatApp> createState() => _ChatAppState();
}

class _ChatAppState extends State<ChatApp> {
  // these are some requirements for this page, where you will be looking
  // up for any users with the matching name to start chatting with.
  // results are saved in searchResults and searchController manages the search
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isSearch = false;
  List<Map> searchResult = [];
  List<dynamic> allMembers = [];

  @override
  Widget build(BuildContext context) {
    final userInfo = Provider.of<UserInApp?>(context);

    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: barColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Messages",
          style: TextStyle(
              color: headingTextColor,
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
        //toolbarHeight: heigth_sc * 0.10,
        flexibleSpace:
            Container(decoration: const BoxDecoration(color: barColor)),
        elevation: 0,
        actions: [
          // FutureBuilder(
          //     future: DatabaseService(user: userInfo).getUsernameList,
          //     builder: (context, AsyncSnapshot snapshot) {
          //       if (snapshot.hasData) {
          //         List data = snapshot.data;
          //         return Padding(
          //             padding: const EdgeInsets.only(top: 20, bottom: 20),
          //             child: newSearchBar(width_sc, heigth_sc,
          //                 searchController, data, scrollController));
          //       }
          //       return Padding(
          //           padding: const EdgeInsets.only(top: 20, bottom: 20),
          //           child:
          //               searchBar(width_sc, heigth_sc, searchController));
          //     }),
          FutureBuilder(
              future: DatabaseService(user: userInfo).getUsernameList,
              builder: (context, AsyncSnapshot snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 9, top: 4),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentPurple,
                    ),
                    child: IconButton(
                      // onPressed: () async {
                      //   isSearch = true;
                      //   searchResult = await DatabaseService(user: userInfo)
                      //       .searchUserByName(searchController.text);
                      //   setState(() {});
                      // },
                      onPressed: () {
                        List data = snapshot.hasData ? snapshot.data : [];

                        showSearch(
                            context: context,
                            delegate: UserSearch(data, userInfo));
                      },
                      icon: const Icon(Icons.search), iconSize: 22,
                    ),
                  ),
                );
              })
        ],
      ),
      body: StreamBuilder(
          stream: DatabaseService(user: userInfo).updateMessagesStream,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.docs.isEmpty) {
                return const Center(
                    heightFactor: 5, child: Text("No Chats Open"));
              }
              List data = snapshot.data.docs;
              data.sort((a, b) => DateTime.parse(
                      '${a['lastTime']!.substring(0, 10)} ${a['lastTime']!.substring(11)}')
                  .compareTo(DateTime.parse(
                      '${b['lastTime']!.substring(0, 10)} ${b['lastTime']!.substring(11)}')));
              data = data.reversed.toList();

              return SizedBox(
                height: heigth_sc - 168,
                child: ListView.builder(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    //separatorBuilder: (context, index) => Divider(),
                    //shrinkWrap: true,
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var friendID = data[index].id;
                      var lastMsg = data[index]['lastMsg'];
                      String lastTime = data[index]['lastTime'];
                      // lastTime = DateTime.parse(lastTime);
                      // lastTime = DateTime(lastTime.year, lastTime.month,
                      //     lastTime.day, lastTime.hour, lastTime.minute);

                      var parsed = DateTime.parse(
                          '${lastTime.substring(0, 10)} ${lastTime.substring(11)}');
                      String displayTime = "";
                      String messageTime12 =
                          DateFormat("hh:mm a").format(parsed);
                      String messageTime = DateFormat("hh:mm").format(parsed);
                      String messageDay = DateFormat("dd").format(parsed);
                      String messageMonth = DateFormat("mm").format(parsed);
                      String messageDate = DateFormat("M/d/yy").format(parsed);
                      String nowTime =
                          DateFormat("hh:mm").format(DateTime.now());
                      String nowDay = DateFormat("dd").format(DateTime.now());
                      String nowMonth = DateFormat("mm").format(DateTime.now());
                      var bolded = false;

                      // This first if statement doesnt work
                      if (nowTime == messageTime) {
                        displayTime = "Now";
                        bolded = true;
                      } else if (nowDay == messageDay) {
                        displayTime = messageTime12;
                      } else if ((int.parse(nowDay) - 1) ==
                          int.parse(messageDay)) {
                        displayTime = "yesterday";
                      } else {
                        displayTime = messageDate;
                      }

                      if (lastMsg.toString().length > 30) {
                        lastMsg = lastMsg.toString().substring(0, 30);
                      }

                      return FutureBuilder(
                          future: DatabaseService(user: userInfo)
                              .getSpecifiedDatabase(friendID),
                          builder: (context, AsyncSnapshot asyncsnapshot) {
                            if (asyncsnapshot.hasData) {
                              var friend = asyncsnapshot.data;
                              return ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 20),
                                  leading: CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(friend['profile_url']),
                                  ),
                                  title: Text(friend['username']),
                                  subtitle: Text(lastMsg,
                                      style: const TextStyle(fontSize: 12)),
                                  trailing: Text(
                                    "$displayTime",
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) => ChatScreen(
                                                friendID: friend['uid'],
                                                friendName: friend['username'],
                                                profile_url:
                                                    friend['profile_url']))));
                                  });
                            }
                            return const LinearProgressIndicator();
                          });
                    }),
              );
            }
            return const SizedBox.shrink();
          }),
      bottomSheet: Container(
        color: barColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
                padding: EdgeInsets.only(left: 16),
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(1);
                      widget.toggleLoad;
                    },
                    icon: const Icon(
                      Icons.groups_rounded,
                      color: Colors.black,
                      size: 25,
                    ))),
            Container(
                child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.textsms_rounded,
                        color: Colors.deepPurple, size: 25))),
            Container(
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(3);
                      widget.toggleLoad;
                    },
                    icon: const Icon(Icons.calendar_month_sharp,
                        color: Colors.black, size: 25))),
            Container(
                padding: EdgeInsets.only(right: 16),
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(4);
                      widget.toggleLoad;
                    },
                    icon: const Icon(Icons.settings,
                        color: Colors.black, size: 25)))
          ],
        ),
      ),
    );
  }
}

class UserSearch extends SearchDelegate<String> {
  List data;
  final userInfo;

  UserSearch(this.data, this.userInfo);

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, '');
        },
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ));
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return buildList(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Get list of users from database
    return buildList(context);
  }

  Widget buildList(BuildContext context) {
    final suggestionList = query.isEmpty
        ? []
        : data
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.person),
            title: Text(suggestionList[index]),
            onTap: () async {
              List<Map> searchResult = await DatabaseService(user: userInfo)
                  .searchUserByName(suggestionList[index]);
              Navigator.of(context).pop();
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatScreen(
                            friendID: searchResult[0]['uid'],
                            friendName: searchResult[0]['username'],
                            profile_url: searchResult[0]['profile_url'],
                          )));
            },
          );
        });
  }
}
