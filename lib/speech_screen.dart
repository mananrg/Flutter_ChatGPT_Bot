import 'package:avatar_glow/avatar_glow.dart';
import 'package:chatgpt_voice_chat/api_service.dart';
import 'package:chatgpt_voice_chat/colors.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:speech_to_text/speech_to_text.dart';

import 'chat_model.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  String apiKey = "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";
  var text="";
  static var header_text = "Hold the button and start speaking";
  var _listening = false;
  final List<ChatMessage> messages = [];
  TextEditingController _textinput = TextEditingController();
  SpeechToText speechToText = SpeechToText();
  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: bgColor,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Chat Bot",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [

            const SizedBox(
              height: 12,
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: chatBgColor,
                ),
                child: ListView(
                  children: [
                    ChatBubble(chattext: "Hello, This is powered by Chat-GPT \n Start by typing, Please wait for response!", type: ChatMessageType.user),
                    ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          var chat = messages[index];
                          return ChatBubble(chattext: chat.text, type: chat.type);
                        }),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5, right: 5, bottom: 10),
              child: SizedBox(
                child: TextField(
                  controller: _textinput,
                  decoration: InputDecoration(
                    hintText: "Enter Message",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    suffixIcon:   GestureDetector(
                      onTap: () async {
                        setState(() {
                          text = _textinput.text;
                          messages.add(
                            ChatMessage(
                                text: text, type: ChatMessageType.user),
                          );
                          _textinput.clear();

                        }

                        );
                        var msg = await ApiServices.sendMessage(text);
                        setState(() {
                          messages.add(ChatMessage(
                              text: msg, type: ChatMessageType.bot));
                        });
                      },
                      child: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget ChatBubble({required chattext, required ChatMessageType? type}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: type == ChatMessageType.bot?Colors.white: bgColor,
          child: type == ChatMessageType.bot
              ? Image.asset('assets/images/bot.png')
              : const Icon(
                  Icons.person,
                  color: Colors.white,
                ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                  bottomLeft: Radius.circular(12)),
            ),
            child: Text(
              "$chattext",
              style: const TextStyle(
                color: chatBgColor,
                fontSize: 15,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
