// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:vonette_mobile/models/user.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:vonette_mobile/shared/constants.dart';

class GroupTextField extends StatefulWidget {
  final String? clubName;
  final UserInApp? user;
  final bool admin;
  const GroupTextField(this.clubName, this.user, this.admin);

  @override
  State<GroupTextField> createState() => _GroupTextFieldState();
}

class _GroupTextFieldState extends State<GroupTextField> {
  final TextEditingController _controller = TextEditingController();
  bool emoji = false;
  FocusNode focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          emoji = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsetsDirectional.all(8),
      child: Column(children: [
        Row(
          children: [
            IconButton(
                icon: Icon(
                  Icons.emoji_emotions,
                  color: widget.admin ? accentPurple : textFieldDisabledColor,
                  size: 30,
                ),
                constraints: const BoxConstraints(maxWidth: 100),
                //splashColor: widget.admin ? Colors.grey : Colors.transparent,
                onPressed: () {
                  focusNode.unfocus();
                  focusNode.canRequestFocus = false;
                  setState(() {
                    emoji = !emoji;
                  });
                }),
            const SizedBox(width: 10),
            Expanded(
                child: TextField(
              enabled: widget.admin,
              focusNode: focusNode,
              controller: _controller,
              decoration: InputDecoration(
                  labelText: widget.admin
                      ? "Type Something"
                      : "Only admins can send messages",
                  border: InputBorder.none,
                  labelStyle: TextStyle(
                      color: widget.admin
                          ? textFieldFocusColor
                          : textFieldDisabledColor)),
              minLines: 1,
              maxLines: 4,
              cursorColor: textFieldFocusColor,
            )),
            const SizedBox(width: 10),
            GestureDetector(
                onTap: () async {
                  String message = _controller.text;
                  _controller.clear();
                  if (message.trim() != '') {
                    DatabaseService(user: widget.user)
                        .addGroupMsgToDB(message, widget.clubName);
                  }
                },
                child: Container(
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: Icon(
                      Icons.send,
                      color:
                          widget.admin ? accentPurple : textFieldDisabledColor,
                      size: 35,
                    )))
          ],
        ),
        if (widget.admin) (emojiSelect())
      ]),
    );
  }

  Widget emojiSelect() {
    //const purple = Color.fromARGB(255, 131, 75, 169);
    return Offstage(
      offstage: !emoji,
      child: SizedBox(
        height: 250,
        child: EmojiPicker(
            config: const Config(
              columns: 7,
              buttonMode: ButtonMode.CUPERTINO,
              iconColorSelected: accentPurple,
              //progressIndicatorColor: accentPurple,
              backspaceColor: accentPurple,
              indicatorColor: accentPurple,
            ),
            onBackspacePressed: () {
              _controller.text =
                  _controller.text.characters.skipLast(1).toString();
            },
            textEditingController: _controller),
      ),
    );
  }
}
