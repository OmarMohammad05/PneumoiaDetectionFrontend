import 'package:breathe_x/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:breathe_x/components/customButton.dart';
import 'package:breathe_x/constants.dart';
class WelcomeScreen extends StatefulWidget {
  static const String id="WelcomeScreen";
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kStack(
           Padding(
              padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,// in this colum in center
              crossAxisAlignment: CrossAxisAlignment.center,// To become vertical
              children:<Widget> [
                Text(
                  "Smarter healthcare & AI-driven insights",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,

                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Get real-time diagnostics and automate patient care.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 30),
              CustomButton(height:50.0,onPressed:()=>Navigator.pushNamed((context), SignUpScreen.id)),

              ],
            ),

          ),
      ),
    );
  }
}

