import 'package:chatgpt_voice_chat/LoginScreen/LoginScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chatgpt_voice_chat/Widgets/RoundedButton.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  static String verify = "";
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  bool _obscureText = true;
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                //cred https://www.flaticon.com/authors/trazobanana
                const Expanded(
                  child: SizedBox(),
                ),

                Image.asset(
                  'assets/images/man.png',
                  height: 100,
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text(
                      "SIGNUP",
                      style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),

                const SizedBox(
                  height: 40,
                ),
                TextFormField(
                  onChanged: (value) {
                    _nameController.text = value;
                  },
                  decoration: const InputDecoration(
                    // border: OutlineInputBorder(),
                    hintText: 'Name',
                    prefixIcon: Icon(Icons.person),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),

                //email id input
                TextFormField(
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
                  height: 15,
                ),

                //password input
                TextFormField(
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
                const Expanded(
                  child: SizedBox(),
                ),
                //signup button
                RoundedButton(
                  text: "Create Account",
                  press: () async {
                    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text) &&
                        _passwordController.text.isNotEmpty) {
                      try {
                        final credential = await FirebaseAuth.instance
                            .createUserWithEmailAndPassword(
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        );
                        ScaffoldMessenger.of(context)
                          ..hideCurrentSnackBar()
                          ..showSnackBar(
                            SnackBar(
                              elevation: 0,
                              behavior: SnackBarBehavior.floating,
                              backgroundColor: Colors.transparent,
                              content: AwesomeSnackbarContent(
                                title: 'Great!',
                                message: 'Successfully Signed Up!',
                                contentType: ContentType.success,
                              ),
                            ),
                          );
                        setState(() {
                          _emailController.text = "";
                          _passwordController.text = "";
                          _nameController.text = "";
                        });
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
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
                    }
                  },
                  color: const Color(0xFF0065FF),
                ),
                const Expanded(
                  child: SizedBox(),
                ),
                //new to login / register
                RichText(
                  text: TextSpan(
                    text: "Have already registered?  ",
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      TextSpan(
                          text: "Login",
                          style: const TextStyle(
                            color: Color(0xFF0065FF),
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
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
      ),
    );
  }
}
