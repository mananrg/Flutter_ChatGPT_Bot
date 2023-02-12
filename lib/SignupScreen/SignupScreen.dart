import 'package:chatgpt_voice_chat/LoginScreen/LoginScreen.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:chatgpt_voice_chat/Widgets/RoundedButton.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebaseStorage;
import 'package:chatgpt_voice_chat/globalVar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../MainScreen/MainScreen.dart';

enum Gender {
  male,
  female,
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();
  bool maleSelected = false;
  bool femaleSelected = false;
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;
  var selected;
  String genderSelected = "";
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();

  void _register(String gender) async {
    late User currentUser;
    await _auth
        .createUserWithEmailAndPassword(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
    )
        .then((auth) async {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Congratulations!',
            message: 'Succesfully Signed Up!',
            contentType: ContentType.success,
          ),
        ));
      currentUser = auth.user!;
      userId = currentUser.uid!;
      userEmail = currentUser.email!;
      getUserName = _nameController.text.trim();

      saveUserData(gender);


    }).catchError((error) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.transparent,
          content: AwesomeSnackbarContent(
            title: 'Error!',
            message:
                '${error.message + '\n Please contact the administrator!'}',
            contentType: ContentType.failure,
          ),
        ));
    });


    if (currentUser != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SpeechScreen(),
        ),
      );
    }
  }

  Future<void> saveUserData(String gender) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('Name', _nameController.text);
    prefs.setString('Gender', gender);
    prefs.setString('Email', _emailController.text);
    Map<String, dynamic> userData = {
      'userName': _nameController.text.trim(),
      'uid': userId,
      'time': DateTime.now(),
      'status': "approved",
      'gender': gender,
      'email': _emailController.text.trim()
    };

    FirebaseFirestore.instance.collection("users").doc(userId).set(userData);
  }

  @override
  Widget build(BuildContext context) {


    double screenWidth = MediaQuery.of(context).size.width;
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
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
                Image.asset(
                  'assets/images/password.png',
                  height: 100,
                ),
                const Expanded(
                  child: SizedBox(),
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
                  obscureText: _obscureTextPassword,
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
                            _obscureTextPassword = !_obscureTextPassword;
                          });
                        },
                        icon: const Icon(Icons.visibility),
                      )),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFormField(
                  obscureText: _obscureTextConfirmPassword,
                  onChanged: (value) {
                    _confirmpasswordController.text = value;
                  },
                  decoration: InputDecoration(

                      // border: OutlineInputBorder(),
                      hintText: 'Confirm Password',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscureTextConfirmPassword =
                                !_obscureTextConfirmPassword;
                          });
                        },
                        icon: const Icon(Icons.visibility),
                      )),
                ),

                const Expanded(
                  child: SizedBox(),
                ),
                Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.44,
                      child: GenderWidget(
                        onclick: () {
                          selected = Gender.male;
                          setState(() {
                            genderSelected = "Male";
                          });
                        },
                        isSelected: Gender.male == selected,
                        title: 'Male',
                        icon: Icons.male,
                        backgroundColor: const Color(0xFF0065FF),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.44,
                      child: GenderWidget(
                          isSelected: Gender.female == selected,
                          onclick: () {
                            selected = Gender.female;


                            setState(() {
                              genderSelected = "Female";
                            });
                          },
                          title: 'Female',
                          icon: Icons.female,
                          backgroundColor: Colors.purpleAccent),
                    ),
                  ],
                ),
                //signup button
                const SizedBox(
                  height: 28,
                ),
                RoundedButton(
                  text: "Create Account",
                  press: () async {
                    if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_emailController.text) &&
                        _passwordController.text ==
                            _confirmpasswordController.text) {
                      try {
                        _register(genderSelected);
                      } catch (e) {
                        print(e);
                      }
                    } else if (_passwordController.text !=
                        _confirmpasswordController.text) {
                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(SnackBar(
                          elevation: 0,
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Colors.transparent,
                          content: AwesomeSnackbarContent(
                            title: 'Password Error!',
                            message: 'Passwords do not match',
                            contentType: ContentType.failure,
                          ),
                        ));
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

class GenderWidget extends StatelessWidget {
  final VoidCallback onclick;
  final String title;
  final IconData icon;
  final Color? backgroundColor;
  final bool isSelected;

  const GenderWidget({
    super.key,
    required this.backgroundColor,
    required this.isSelected,
    required this.onclick,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onclick,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
        ),
        //change color based on your need
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.black),
            ),
            Icon(
              icon,
              ////??? What variable should i use to finish
              color: isSelected == true ? backgroundColor : Colors.black,
              size: 80,
            ),
            SizedBox(
              height: 20,
              //??? What variable should i use to finish
              child: isSelected == true
                  ? const Text(
                      'Selected',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black),
                    )
                  : null,
            )
          ],
        )),
      ),
    );
  }
}
