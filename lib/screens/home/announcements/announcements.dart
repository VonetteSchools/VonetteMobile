// ignore_for_file: depend_on_referenced_packages, use_key_in_widget_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/announcements/groupChat.dart';
import 'package:vonette_mobile/screens/home/announcements/pwdVerification.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/screens/wrapper/pwdVerfication2.dart';

class Announcements extends StatefulWidget {
  final Function? togglePage;
  final Function? toggleLoad;
  const Announcements({this.togglePage, this.toggleLoad});

  @override
  State<Announcements> createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  TextEditingController searchController = TextEditingController();
  ScrollController scrollController = ScrollController();
  bool isLoading = false;
  bool isSearch = false;
  int counter = 0;
  List<Map> searchResult = [];

  bool checkPresent(List<dynamic> list, UserInApp? user) {
    for (final objs in list) {
      if (objs.toString() == user?.uid.toString()) {
        return true;
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);

    return Scaffold(
      backgroundColor: barColor,
      appBar: AppBar(
        centerTitle: false,
        title: const Text(
          "Announcements",
          style: TextStyle(
              color: headingTextColor,
              fontSize: 28,
              fontWeight: FontWeight.bold),
        ),
        flexibleSpace:
            Container(decoration: const BoxDecoration(color: barColor)),
        elevation: 0,
        actions: [
          FutureBuilder(
              future: DatabaseService(user: user).getClubListData,
              builder: (context, AsyncSnapshot snapshot) {
                return Padding(
                  padding: const EdgeInsets.only(right: 9, top: 4),
                  child: Container(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: accentPurple,
                    ),
                    child: IconButton(
                      onPressed: () {
                        showSearch(
                            context: context,
                            delegate: ClubSearch(
                                snapshot.hasData ? snapshot.data : [],
                                user,
                                checkPresent));
                      },
                      icon: const Icon(Icons.search),
                      iconSize: 22,
                    ),
                  ),
                );
              })
        ],
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.only(top: 12.0),
          child: StreamBuilder(
              stream: DatabaseService(user: user).updateCounsellorSnapshot,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data.docs.isEmpty) {
                    return const Center(
                        heightFactor: 5, child: Text("No Counselor Available"));
                  }
                  return SizedBox(
                    height: heigth_sc - 725,
                    child: ListView.builder(
                        //shrinkWrap: true,
                        itemCount: snapshot.data.docs.length,
                        itemBuilder: (context, index) {
                          var admin = false;
                          var counsellorPic =
                              snapshot.data.docs[index]['profile_url'];
                          var counsellorName =
                              snapshot.data.docs[index]['counsellor_name'];
                          var counsellorEmail =
                              snapshot.data.docs[index]['counsellor_email'];
                          List<dynamic> clubMembers =
                              snapshot.data.docs[index]['club_members'];
                          List<dynamic> adminMembers =
                              snapshot.data.docs[index]['admin_members'];

                          if (checkPresent(clubMembers, user) ||
                              checkPresent(adminMembers, user)) {
                            counter += 1;
                            if (checkPresent(adminMembers, user)) {
                              admin = true;
                            }
                            return FutureBuilder(
                                future: DatabaseService(user: user)
                                    .getSpecifiedDatabase(counsellorName),
                                builder:
                                    (context, AsyncSnapshot asyncsnapshot) {
                                  if (asyncsnapshot.hasData) {
                                    return ListTile(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 20),
                                        leading: CircleAvatar(
                                            backgroundImage:
                                                NetworkImage(counsellorPic)),
                                        title: Text(counsellorName),
                                        subtitle: Text(
                                          'Email: $counsellorEmail',
                                          style: const TextStyle(fontSize: 12),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      GroupChat(
                                                        clubName:
                                                            counsellorName,
                                                        admin: admin,
                                                        profileUrl:
                                                            counsellorPic,
                                                        isCounsellor: true,
                                                      ))));
                                        });
                                  }
                                  return const SizedBox.shrink();
                                });
                          }
                          if (counter == 0 &&
                              index == snapshot.data.docs.length - 1) {
                            return const Center(
                                heightFactor: 5,
                                child: Text("No Counsellor Available"));
                          }
                          return const SizedBox.shrink();
                        }),
                  );
                }
                return const LinearProgressIndicator();
              }),
        ),
        Container(
            padding: const EdgeInsets.only(left: 20, top: 15),
            alignment: Alignment.topLeft,
            child: const Text("Clubs",
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold))),
        StreamBuilder(
            stream: DatabaseService(user: user).updateClubSnapshot,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data.docs.isEmpty) {
                  return const Center(
                      heightFactor: 5, child: Text("No Clubs Open"));
                }
                return SizedBox(
                  height: heigth_sc - 290,
                  child: ListView.builder(
                      //shrinkWrap: true,
                      itemCount: snapshot.data.docs.length,
                      itemBuilder: (context, index) {
                        var clubPic = snapshot.data.docs[index]['profile_url'];
                        var admin = false;
                        var clubName = snapshot.data.docs[index]['club_name'];
                        var clubDesc = snapshot.data.docs[index]['club_desc'];
                        List<dynamic> clubMembers =
                            snapshot.data.docs[index]['club_members'];
                        List<dynamic> adminMembers =
                            snapshot.data.docs[index]['admin_members'];

                        if (checkPresent(clubMembers, user) ||
                            checkPresent(adminMembers, user)) {
                          counter += 1;
                          if (checkPresent(adminMembers, user)) {
                            admin = true;
                          }
                          return FutureBuilder(
                              future: DatabaseService(user: user)
                                  .getSpecifiedDatabase(clubName),
                              builder: (context, AsyncSnapshot asyncsnapshot) {
                                if (asyncsnapshot.hasData) {
                                  return ListTile(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      leading: CircleAvatar(
                                        backgroundImage: NetworkImage(clubPic),
                                      ),
                                      title: Text(clubName),
                                      subtitle: Text(
                                        clubDesc,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: ((context) =>
                                                    GroupChat(
                                                      clubName: clubName,
                                                      admin: admin,
                                                      profileUrl: clubPic,
                                                      isCounsellor: false,
                                                    ))));
                                      });
                                }
                                return const SizedBox.shrink();
                              });
                        }
                        if (counter == 0 &&
                            index == snapshot.data.docs.length - 1) {
                          return const Center(
                              heightFactor: 5, child: Text("No Clubs Open"));
                        }
                        return const SizedBox.shrink();
                      }),
                );
              }
              return const LinearProgressIndicator();
            }),
      ]),
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
                      color: Colors.deepPurple,
                      size: 25,
                    ))),
            Container(
                child: IconButton(
                    onPressed: () {
                      widget.togglePage!(2);
                      widget.toggleLoad;
                    },
                    icon: const Icon(Icons.textsms_rounded,
                        color: Colors.black, size: 25))),
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

class ClubSearch extends SearchDelegate<String> {
  dynamic clubInformation;
  final userInfo;
  Function checkPresent;

  ClubSearch(this.clubInformation, this.userInfo, this.checkPresent);

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
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: Get list of users from database
    List<String> data = [];
    for (final objs in clubInformation) {
      data.add(objs["club_name"]);
    }
    final suggestionList = query.isEmpty
        ? []
        : data
            .where((p) => p.toLowerCase().startsWith(query.toLowerCase()))
            .toList();

    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.groups),
            title: Text(suggestionList[index]),
            trailing: IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                bool condition = false;
                for (final objs in clubInformation) {
                  if (objs["club_name"] == suggestionList[index]) {
                    condition = objs["private"];
                    break;
                  }
                }
                if (condition) {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => PasswordVerification(
                                clubName: suggestionList[index],
                              ))));
                } else {
                  Navigator.of(context).pop();
                  DatabaseService(user: userInfo)
                      .updateClubMemberList(suggestionList[index]);
                }
              },
            ),
          );
        });
  }
}
