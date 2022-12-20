import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/announcements/setPassword.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:vonette_mobile/screens/home/announcements/clubSettings.dart';
import 'package:vonette_mobile/screens/home/chatApp/chatScreen.dart';

class ParticipantsPage extends StatefulWidget {
  final String clubName;
  final List studentsUID;
  final List adminUID;
  final bool admin;
  final bool isCounsellor;
  final String profileUrl;
  final bool? isPrivate;
  final String? privatePassword;

  const ParticipantsPage(
      {super.key,
      required this.clubName,
      required this.studentsUID,
      required this.adminUID,
      required this.admin,
      required this.isCounsellor,
      required this.profileUrl,
      this.isPrivate,
      this.privatePassword});

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  @override
  Widget build(BuildContext context) {
    double heigth_sc = MediaQuery.of(context).size.height;
    double width_sc = MediaQuery.of(context).size.width;
    final user = Provider.of<UserInApp?>(context);

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(heigth_sc * 0.07),
          child: AppBar(
            centerTitle: false,
            title: const Text("Participants"),
            flexibleSpace: Container(
              color: purpleBarColor,
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.more_horiz_outlined),
                onPressed: () {
                  if (widget.isCounsellor == true) {
                    showDialog(
                        context: context,
                        builder: (context) => SizedBox(
                            height: 500,
                            child: AlertDialog(
                                scrollable: true,
                                title: const Text('Group Settings'),
                                content: FractionallySizedBox(
                                  widthFactor: 1,
                                  child: TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  inksplashColor)),
                                      child: const DefaultTextStyle(
                                          style: TextStyle(color: Colors.black),
                                          child: Text('No Settings Options')),
                                      onPressed: () {}),
                                ))));
                  } else {
                    if (widget.admin == false) {
                      showDialog(
                          context: context,
                          builder: (context) => SizedBox(
                              height: 500,
                              child: AlertDialog(
                                  scrollable: true,
                                  title: const Text('Group Settings'),
                                  content: FractionallySizedBox(
                                    widthFactor: 1,
                                    child: TextButton(
                                      style: ButtonStyle(
                                          overlayColor:
                                              MaterialStateProperty.all(
                                                  inksplashColor)),
                                      child: const DefaultTextStyle(
                                          style: TextStyle(color: Colors.black),
                                          child: Text('Exit Group')),
                                      onPressed: () {
                                        DatabaseService(user: user)
                                            .removeClubMemberList(
                                                widget.clubName);
                                        Navigator.of(context)
                                            .popUntil((route) => route.isFirst);
                                      },
                                    ),
                                  ))));
                    } else if (widget.admin == true) {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: ((context) => ClubSettings(
                                  profileUrl: widget.profileUrl,
                                  clubName: widget.clubName,
                                  adminList: widget.adminUID,
                                  isPrivate: widget.isPrivate,
                                  privatePassword: widget.privatePassword))));
                    }
                  }
                },
              )
            ],
          )),
      body: SingleChildScrollView(
        child: Column(children: [
          const SizedBox(height: 15),
          ListView.builder(
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: widget.adminUID.length,
            itemBuilder: (context, index) {
              return FutureBuilder(
                future: DatabaseService(user: user)
                    .getSpecifiedDatabase(widget.adminUID[index]),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListTile(
                      title: Text(snapshot.data['username']),
                      subtitle: Text(snapshot.data['email']),
                      trailing: const Text("Admin"),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(snapshot.data['profile_url']),
                      ),
                    );
                  }
                  return const LinearProgressIndicator();
                },
              );
            },
          ),
          if (widget.admin == false)
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.studentsUID.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: DatabaseService(user: user)
                      .getSpecifiedDatabase(widget.studentsUID[index]),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        title: Text(snapshot.data['username']),
                        subtitle: Text(snapshot.data['email']),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data['profile_url']),
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => SizedBox(
                                height: 500,
                                child: AlertDialog(
                                  scrollable: true,
                                  title: const Text('User Actions'),
                                  content: Column(
                                    children: [
                                      FractionallySizedBox(
                                        widthFactor: 1,
                                        child: TextButton(
                                          style: ButtonStyle(
                                              overlayColor:
                                                  MaterialStateProperty.all(
                                                      inksplashColor)),
                                          child: const DefaultTextStyle(
                                              style: TextStyle(
                                                  color: Colors.black),
                                              child: Text('Direct Message')),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        ChatScreen(
                                                            friendID: snapshot
                                                                .data['uid'],
                                                            friendName:
                                                                snapshot.data[
                                                                    'username'],
                                                            profile_url: snapshot
                                                                    .data[
                                                                'profile_url']))));
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        },
                      );
                    }
                    return const LinearProgressIndicator();
                  },
                );
              },
            )
          else if (widget.admin == true)
            ListView.builder(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.studentsUID.length,
              itemBuilder: (context, index) {
                return FutureBuilder(
                  future: DatabaseService(user: user)
                      .getSpecifiedDatabase(widget.studentsUID[index]),
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.hasData) {
                      return ListTile(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => SizedBox(
                              height: 500,
                              child: AlertDialog(
                                scrollable: true,
                                title: const Text('Admin Actions'),
                                content: Column(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    inksplashColor)),
                                        child: const DefaultTextStyle(
                                            style:
                                                TextStyle(color: Colors.black),
                                            child: Text('Promote to Admin')),
                                        onPressed: () {
                                          DatabaseService(user: user)
                                              .updateClubAdminList2(
                                                  widget.clubName,
                                                  snapshot.data['uid']);
                                          DatabaseService(user: user)
                                              .removeClubMemberList2(
                                                  widget.clubName,
                                                  snapshot.data['uid']);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    inksplashColor)),
                                        child: const DefaultTextStyle(
                                            style:
                                                TextStyle(color: Colors.black),
                                            child: Text('Remove from Channel')),
                                        onPressed: () {
                                          DatabaseService(user: user)
                                              .removeClubMemberList2(
                                                  widget.clubName,
                                                  snapshot.data['uid']);
                                          Navigator.of(context).pop();
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ),
                                    FractionallySizedBox(
                                      widthFactor: 1,
                                      child: TextButton(
                                        style: ButtonStyle(
                                            overlayColor:
                                                MaterialStateProperty.all(
                                                    inksplashColor)),
                                        child: const DefaultTextStyle(
                                            style:
                                                TextStyle(color: Colors.black),
                                            child: Text('Direct Message')),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: ((context) =>
                                                      ChatScreen(
                                                          friendID: snapshot
                                                              .data['uid'],
                                                          friendName:
                                                              snapshot.data[
                                                                  'username'],
                                                          profile_url: snapshot
                                                                  .data[
                                                              'profile_url']))));
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                        title: Text(snapshot.data['username']),
                        subtitle: Text(snapshot.data['email']),
                        leading: CircleAvatar(
                          backgroundImage:
                              NetworkImage(snapshot.data['profile_url']),
                        ),
                      );
                    }
                    return const LinearProgressIndicator();
                  },
                );
              },
            ),
        ]),
      ),
    );
  }
}
