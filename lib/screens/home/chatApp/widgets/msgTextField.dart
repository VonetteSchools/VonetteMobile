// ignore_for_file: use_key_in_widget_constructors, depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:vonette_mobile/services/database.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:vonette_mobile/shared/constants.dart';

class MessageTextField extends StatefulWidget {
  final String? currentId;
  final String? friendId;
  const MessageTextField(this.currentId, this.friendId);

  @override
  State<MessageTextField> createState() => _MessageTextFieldState();
}

class _MessageTextFieldState extends State<MessageTextField> {
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
                icon: const Icon(Icons.emoji_emotions,
                    color: accentPurple, size: 30),
                constraints: const BoxConstraints(maxWidth: 100),
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
              focusNode: focusNode,
              controller: _controller,
              decoration: const InputDecoration(
                  labelText: "Type Something",
                  border: InputBorder.none,
                  labelStyle: TextStyle(color: textFieldFocusColor)),
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
                    DatabaseService().addMessagesToDM(
                        message, widget.currentId, widget.friendId);
                  }
                },
                child: Container(
                    padding: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                    child: const Icon(
                      Icons.send,
                      color: accentPurple,
                      size: 35,
                    )))
          ],
        ),
        (emojiSelect())
      ]),
    );
  }

  Widget emojiSelect() {
    const purple = Color.fromARGB(255, 131, 75, 169);
    return Offstage(
        offstage: !emoji,
        child: SizedBox(
            height: 250,
            child: EmojiPicker(
                config: const Config(
                  columns: 7,
                  buttonMode: ButtonMode.CUPERTINO,
                  iconColorSelected: purple,
                  //progressIndicatorColor: purple,
                  backspaceColor: purple,
                  indicatorColor: purple,
                ),
                onBackspacePressed: () {
                  _controller.text =
                      _controller.text.characters.skipLast(1).toString();
                },
                textEditingController: _controller)));
  }
}
