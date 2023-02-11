import 'dart:async';

import 'package:chatgpt_voice_chat/MainScreen/MainScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chatgpt_voice_chat/Widgets/RoundedButton.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({Key? key}) : super(key: key);
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text(
                "Reset your Password",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                onChanged: (value) {
                  _emailController.text = value;
                },
                decoration: const InputDecoration(
                  // border: OutlineInputBorder(),
                  hintText: 'Email ID',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              RoundedButton(
                text: 'Submit',
                press: () async {
                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                        email: _emailController.text.trim());
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'On Snap!',
                        message:
                            'Reset link sent, please check your Inbox/Spam!',
                        contentType: ContentType.help,
                      ),
                    );

                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(snackBar);
                    Timer(const Duration(seconds: 3), () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SpeechScreen(),
                        ),
                      );
                    });
                  } on FirebaseAuthException catch (e) {
                    if (kDebugMode) {
                      print("******************");
                      print(e.code);
                      print("******************");

                      final snackBar = SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: e.code,
                          contentType: ContentType.failure,
                        ),
                      );
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(snackBar);
                    }
                  }
                },
                color: const Color(0xFF0065FF),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
