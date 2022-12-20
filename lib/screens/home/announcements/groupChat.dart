// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages, non_constant_identifier_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/announcements/participants.dart';
import 'package:vonette_mobile/screens/home/announcements/widgets/groupTextField.dart';
import 'package:vonette_mobile/screens/home/chatApp/widgets/singleMessage.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:vonette_mobile/shared/loading.dart';
import 'package:provider/provider.dart';

class GroupChat extends StatelessWidget {
  final String clubName;
  final bool admin;
  final String profileUrl;
  final bool isCounsellor;

  const GroupChat(
      {required this.clubName,
      required this.admin,
      required this.profileUrl,
      required this.isCounsellor});

  @override
  Widget build(BuildContext context) {
    // these conditions are used to get the height and the width of the screen
    // which are helpful in generating percentage values.
    double heigth_sc = MediaQuery.of(context).size.height;
    final currentUser = Provider.of<UserInApp?>(context);

    return Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: headingIconColor, //change your color here
          ),
          titleSpacing: 0,
          centerTitle: true,
          elevation: 0,
          flexibleSpace:
              Container(decoration: const BoxDecoration(color: barColor)),
          toolbarHeight: heigth_sc * 0.1,
          toolbarOpacity: 1,
          title: Row(
            children: [
              CircleAvatar(backgroundImage: NetworkImage(profileUrl)),
              const SizedBox(width: 10),
              SizedBox(
                width: 210,
                child: Text(
                  clubName,
                  style: const TextStyle(fontSize: 23, color: headingTextColor),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                icon: const Icon(
                  Icons.people,
                  size: 29,
                ),
                onPressed: () async {
                  if (isCounsellor) {
                    var clubMemberInfo =
                        await DatabaseService(user: currentUser)
                            .specifiedCounsellorSnapshot(clubName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ParticipantsPage(
                                clubName: clubName,
                                studentsUID:
                                    clubMemberInfo.data()['club_members'],
                                adminUID:
                                    clubMemberInfo.data()['admin_members'],
                                admin: admin,
                                isCounsellor: isCounsellor,
                                profileUrl: profileUrl))));
                  } else {
                    var clubMemberInfo =
                        await DatabaseService(user: currentUser)
                            .specifiedClubSnapshot(clubName);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => ParticipantsPage(
                                clubName: clubName,
                                studentsUID:
                                    clubMemberInfo.data()['club_members'],
                                adminUID:
                                    clubMemberInfo.data()['admin_members'],
                                admin: admin,
                                isCounsellor: isCounsellor,
                                profileUrl: profileUrl,
                                privatePassword:
                                    clubMemberInfo.data()['private_password'],
                                isPrivate: clubMemberInfo.data()['private']))));
                  }
                },
              ),
            )
          ],
        ),
        body: Column(children: [
          Expanded(
              child: Container(
                  color: backgroundColor,
                  padding:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                  child: StreamBuilder(
                      stream: DatabaseService(user: currentUser)
                          .updateClubChatsStream(clubName),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isEmpty) {
                            return Center(
                                child: admin
                                    ? Text('Make an announcement!')
                                    : Text('Nothing for now...'));
                          }
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isMe = snapshot.data.docs[index]
                                        ['userID'] ==
                                    currentUser?.uid;
                                return SingleMessage(
                                    message: snapshot.data.docs[index]
                                        ['message'],
                                    isMe: isMe,
                                    time: snapshot.data.docs[index]["date"]);
                              });
                        }
                        return const Loading();
                      }))),
          GroupTextField(clubName, currentUser, admin),
        ]));
  }
}
