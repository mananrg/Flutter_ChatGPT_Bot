import 'dart:async';

import 'package:chatgpt_voice_chat/SignupScreen/SignupScreen.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_voice_chat/LoginScreen/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatgpt_voice_chat/MainScreen/MainScreen.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer() {
    Timer(
      const Duration(seconds: 3),
      () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var email = prefs.getString("email");
        email == null
            ? Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) =>SignupScreen(),),)
            : Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoginScreen(),),);
      },
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
      startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          const Expanded(
            child: SizedBox(),
          ),
          Center(
            child: Lottie.asset('assets/animations/lottie.json'),
          ),
          const Expanded(
            child: SizedBox(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[ SizedBox(
              child: DefaultTextStyle(
                style: const TextStyle(
                  fontSize: 30.0,
                  fontFamily: 'Agne',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C75D6),
                ),
                child: AnimatedTextKit(

                  animatedTexts: [
                    TypewriterAnimatedText("AI Chat App"),
                  ],
                ),
              ),
            ),],
          ),

          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
