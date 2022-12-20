// ignore_for_file: file_names, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:vonette_mobile/shared/constants.dart';

class GroupMsg extends StatelessWidget {
  final String message;
  final bool isMe;
  final dynamic time;
  const GroupMsg(
      {required this.isMe, required this.message, required this.time});

  @override
  Widget build(BuildContext context) {
    var updatedTime =
        "${time.toDate().hour.toString().padLeft(2, '0')}:${time.toDate().minute.toString().padLeft(2, '0')}";
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              constraints: const BoxConstraints(maxWidth: 200),
              decoration: BoxDecoration(
                color: isMe ? messageMeColor : messageFriendColor,
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              padding: const EdgeInsets.all(12),
              margin:
                  const EdgeInsets.only(top: 8, left: 8, right: 8, bottom: 2),
              child: Text(
                message,
                style: TextStyle(color: isMe ? textMeColor : textFriendColor),
              ),
            ),
            Container(
              margin: isMe
                  ? const EdgeInsets.only(right: 10, bottom: 5)
                  : const EdgeInsets.only(left: 10, bottom: 5),
              child: Text(
                updatedTime,
                style: const TextStyle(fontSize: 10),
              ),
            )
          ],
        ),
      ],
    );
  }
}
