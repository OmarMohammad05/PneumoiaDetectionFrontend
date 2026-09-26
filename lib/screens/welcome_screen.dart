import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'sign_up.dart';
import 'package:breathe_x/components/customButton.dart';
import 'package:breathe_x/accounts/patients_screen.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});
  static const String id='WelcomeScreen';

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    controller.forward();
    controller.addListener(() {
      setState(() {});
    });
    animation=ColorTween(
      begin: Color(0xFFdae8e6),
      end: Color(0xFFF5FFFA) ,// Beige
    ).animate(controller);
  }
  void checkLoginStatus() async{
    await Future.delayed(Duration(seconds: 2));
    final user = FirebaseAuth.instance.currentUser;
    if(user !=null){
      Navigator.pushReplacementNamed(context, PatientsScreen.id);
    }
    else {
      Navigator.pushReplacementNamed(context, LogInScreen.id);
    }

  }
  void dispose(){
    super.dispose();
    controller.dispose();
    checkLoginStatus();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:animation.value,
      body: SafeArea(
        child: Padding(
            padding: EdgeInsets.symmetric(vertical: 200.0, horizontal: 10.0),
          child: ListView(
           // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //crossAxisAlignment: CrossAxisAlignment.stretch,
            children:<Widget> [
              Center(
                child: Text(
                  'BreathX Application',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF333333),
                  ),
                ),
              ),
              SizedBox(height:50.0,),
              CustomButton(
                height: 50.0,
                text: "Log in",
                onPressed: (){
                  Navigator.pushNamed((context),LogInScreen.id);
                },
              ),
              SizedBox(height:20.0,),
              CustomButton(
                height: 50.0,
                text: "Sign up ",
              onPressed: (){
                Navigator.pushNamed((context),SignUpScreen.id);
              },
              ),
              SizedBox(height:15.0,),

            ],
          ),
        ),
      )
    );
  }
}

