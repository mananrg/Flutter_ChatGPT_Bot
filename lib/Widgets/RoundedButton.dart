import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback press;
  final Color color, textColor;
 const RoundedButton({
    Key? key,
    required this.text,
    required this.press,
    required this.color ,
    this.textColor = Colors.white,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.8,
      height: 50,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary:  color,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
          ),
          onPressed: press,
          child: Text(
            text,
            style: TextStyle(color: textColor,fontSize: 17),
          ),
        ),
      ),
    );
  }
}
