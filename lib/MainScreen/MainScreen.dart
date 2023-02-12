import 'package:chatgpt_voice_chat/LoginScreen/LoginScreen.dart';
import 'package:chatgpt_voice_chat/Widgets/ApiServices.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../Widgets/ChatModels.dart';
import '../Widgets/constants.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({Key? key}) : super(key: key);

  @override
  State<SpeechScreen> createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  String apiKey = "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";
  var text = "";
  final List<ChatMessage> messages = [];
  final TextEditingController _textinput = TextEditingController();
  SpeechToText speechToText = SpeechToText();
  var scrollController = ScrollController();
  scrollMethod() {
    scrollController.animateTo(scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      drawer: MainDrawer(),
      appBar: AppBar(
        backgroundColor: Constants.bgColor,
        centerTitle: true,
        elevation: 0.0,
        title: const Text(
          "Chat Bot",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: Colors.white,
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
                  color: Constants.chatBgColor,
                ),

                child: ListView(
                  children: [
                    ChatBubble(
                        chattext:
                            "Hello , This is powered by Chat-GPT \n Start by typing, Please wait for response!",
                        type: ChatMessageType.bot),
                    const SizedBox(
                      height: 6,
                    ),
                    ListView.builder(
                        controller: scrollController,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: messages.length,
                        itemBuilder: (BuildContext context, int index) {
                          var chat = messages[index];
                          return Column(
                            children: [
                              ChatBubble(chattext: chat.text?.trim(), type: chat.type),
                              const SizedBox(
                                height: 6,
                              )
                            ],
                          );
                        })
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
                      borderSide: const BorderSide(
                          color: Constants.borderColor, width: 2.0),
                    ),
                    suffixIcon: GestureDetector(
                      onTap: () async {
                        setState(() {
                          text = _textinput.text;
                          messages.add(
                            ChatMessage(text: text, type: ChatMessageType.user),
                          );
                          _textinput.clear();
                        });
                        var msg = await ApiServices.sendMessage(text);
                        setState(() {
                          messages.add(ChatMessage(
                              text: msg, type: ChatMessageType.bot));
                        });
                      },
                      child: const Icon(
                        Icons.arrow_forward,
                        color: Colors.black,
                      ),
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
    return type == ChatMessageType.bot
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Image.asset('assets/images/bot.png')),
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
                      color: Constants.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                        bottomLeft: Radius.circular(12)),
                  ),
                  child: Text(
                    "$chattext",
                    style: const TextStyle(
                      color: Constants.textColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              CircleAvatar(
                backgroundColor: const Color(0xffFEEAA5),
                child: Image.asset("assets/icons/man.png"),
              ),
            ],
          );
  }

  MainDrawer() {
    return Drawer(
      width: 150,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: Column(
        // Important: Remove any padding from the ListView.
        children: [
          const SizedBox(
            height: 60,
          ),
          const Center(
            child: Text(
              "PROFILE",
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Container(
            height: 1,
            color: Colors.black,
          ),
          TextButton(
            child: const Text(
              'CLEAR CHAT',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onPressed: () {
              setState(() {
                messages.clear();

              });
            },
          ),
          TextButton(
            child: const Text(
              'LOGOUT',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
