import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  CustomButton({super.key,
    required this.height,
    this.text="Get Started",
    this.colour=const [Color(0xFFD1D98C),Color(0xFF7CC0A9)],
    this.colorText=const Color(0xFF1A2F17),
    this.width=200,
  required this.onPressed,
  });
  final String  text;
  final List<Color>  colour;
  final Function onPressed;
  final double height;
  final Color colorText;
  final double width;


  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)
            )
        ),
        onPressed:() =>onPressed(),
        child: Ink(
          height: height,
          width: width,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colour,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                color: colorText,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ),

        ));
  }
}
