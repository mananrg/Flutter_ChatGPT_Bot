import 'package:chatgpt_voice_chat/MainScreen/MainScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_voice_chat/Widgets/RoundedButton.dart';
import 'package:chatgpt_voice_chat/ResetPasswordScreen/ResetPasswordScreen.dart';
import 'package:chatgpt_voice_chat/SignupScreen/SignupScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              //cred https://www.flaticon.com/authors/freepik
              Image.asset(
                'assets/images/people.png',
                height: 200,
              ),
              const Expanded(child: SizedBox()),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: const [
                  Text(
                    "LOGIN",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const Expanded(
                child: SizedBox(),
              ),
              //email id input
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
                height: 20,
              ),
              //password input
              TextField(
                obscureText: _obscureText,
                onChanged: (value) {
                  _passwordController.text = value;
                },
                decoration: InputDecoration(

                    // border: OutlineInputBorder(),
                    hintText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      icon: const Icon(Icons.visibility),
                    )),
              ),
              const SizedBox(
                height: 8,
              ),
              //forgot password
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    child: const Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: Color(0xFF0065FF),
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResetPasswordScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
              //login button
              const Expanded(child: SizedBox()),
              RoundedButton(
                text: "Login",
                press: () async {
                  try {
                    final credential =
                        await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );
                    setState(() {
                      _emailController.text = "";
                      _passwordController.text = "";
                    });
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.setString("email", "useremail@gmail.com");
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'Congratulations!',
                          message: 'Succesfully Logged In!',
                          contentType: ContentType.success,
                        ),
                      ));
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SpeechScreen(),
                      ),
                    );
                  } on FirebaseAuthException catch (e) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(SnackBar(
                        elevation: 0,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.transparent,
                        content: AwesomeSnackbarContent(
                          title: 'On Snap!',
                          message: '${e.message}',
                          contentType: ContentType.failure,
                        ),
                      ));
                  }
                },
                color: const Color(0xFF0065FF),
              ),
              //or

              //sign in with google

              const Expanded(
                child: SizedBox(),
              ),

              const Expanded(
                child: SizedBox(),
              ),
              //new to login / register
              RichText(
                text: TextSpan(
                  text: "New to Login?  ",
                  style: const TextStyle(color: Colors.black, fontSize: 14),
                  children: [
                    TextSpan(
                        text: "Register",
                        style: const TextStyle(
                          color: Color(0xFF0065FF),
                          fontWeight: FontWeight.bold,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SignupScreen(),
                              ),
                            );
                          }),
                  ],
                ),
              ),
              const SizedBox(
                height: 22,
              )
            ],
          ),
        ),
      ),
    );
  }
}
