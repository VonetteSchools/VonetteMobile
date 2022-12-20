// ignore_for_file: use_key_in_widget_constructors, non_constant_identifier_names, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/screens/home/chatApp/widgets/msgTextField.dart';
import 'package:vonette_mobile/screens/home/chatApp/widgets/singleMessage.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:vonette_mobile/shared/constants.dart';
import 'package:vonette_mobile/shared/loading.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  final String friendID;
  final String friendName;
  final String profile_url;

  const ChatScreen(
      {required this.friendID,
      required this.friendName,
      required this.profile_url});

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
              CircleAvatar(backgroundImage: NetworkImage(profile_url)),
              const SizedBox(width: 10),
              Text(friendName,
                  style: const TextStyle(fontSize: 23, color: Colors.black))
            ],
          ),
        ),
        body: Column(children: [
          Expanded(
              child: Container(
                  decoration: const BoxDecoration(
                    color: backgroundColor,
                  ),
                  padding:
                      const EdgeInsets.only(right: 10, left: 10, bottom: 10),
                  child: StreamBuilder(
                      stream: DatabaseService(user: currentUser)
                          .updateChatsStream(friendID),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isEmpty) {
                            return const Center(child: Text('Say Hi!!'));
                          }
                          return ListView.builder(
                              itemCount: snapshot.data.docs.length,
                              reverse: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                bool isMe = snapshot.data.docs[index]
                                        ['senderID'] ==
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
          MessageTextField(currentUser?.uid, friendID),
        ]));
  }
}
