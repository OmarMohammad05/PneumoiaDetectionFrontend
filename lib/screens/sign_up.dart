import 'package:breathe_x/constants.dart';
import 'package:flutter/material.dart';
import 'package:breathe_x/components/customButton.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:breathe_x/screens/loading_screen.dart';
import 'sign_in.dart';
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static const String id='SignUpScreen';
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth=FirebaseAuth.instance;
  String email="";
   String password=" ";
   String confirmPassword=" ";
  bool _isHiddenPassword = true;
  bool _isHiddenConfirm = true;
  String errorMessage='';
  bool showSpinner=false;  // For loading screen to understand user there is load in the backend.
  String ? messageError;
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        showSpinner = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: kStack(
          ModalProgressHUD(
            inAsyncCall: showSpinner,
            child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: ListView(
                    children: <Widget>[

                      SizedBox(height:80.0,),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Create your account",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 26.0
                            ),
                          ),
                          SizedBox(height: 15.0,),
                          Text(
                            "Join us get smart healthcare insight",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 15.0
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height:50.0,),
                      TextField(
                        style: TextStyle(
                            color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: kTextField,
                        onChanged: (value) {
                          email = value;
                        },
                      ),
                      SizedBox(height: 18.0,),
                      TextField(
                        style: TextStyle(
                            color: Colors.white
                        ),
                        obscureText: _isHiddenPassword,
                        textAlign: TextAlign.center,
                        decoration: kTextField.copyWith(
                          prefixIcon: Icon(Icons.lock),
                            hintText: "Enter your password",
                            suffixIcon: IconButton(onPressed: () {
                              setState(() {
                                _isHiddenPassword = !_isHiddenPassword;
                              });
                            },
                                icon: Icon(_isHiddenPassword ? Icons.visibility_off : Icons
                                    .visibility))
                        ),
                        onChanged: (value) {
                          password = value;
                        },
                      ),
                      SizedBox(height: 18.0,),
                      TextField(
                        style: TextStyle(
                            color: Colors.white
                        ),
                        obscureText: _isHiddenConfirm,
                        textAlign: TextAlign.center,
                        decoration: kTextField.copyWith(
                          prefixIcon: Icon(Icons.lock_outline),
                            hintText: "Confirm password",
                            suffixIcon: IconButton(onPressed: () {
                              setState(() {
                                _isHiddenConfirm = !_isHiddenConfirm;
                              });
                            },
                                icon: Icon(_isHiddenConfirm ? Icons.visibility_off : Icons
                                    .visibility))

                        ),
                        onChanged: (value) {
                          confirmPassword = value;
                        },
                      ),
                      SizedBox(height: 15.0,),
                      if (messageError != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: Text(
                            messageError!,
                            style: const TextStyle(color: Colors.red, fontSize: 12.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      SizedBox(height: 12.0,),
                      CustomButton(
                          height: 50.0,
                          text: "Sign Up",
                          onPressed: () async {
                            setState(() {
                              messageError = null;
                              showSpinner = true;
                            });
                            Future.delayed(Duration(seconds: 5), () {
                              setState(() {
                                showSpinner = false;
                              });
                            });

                            if (email.isEmpty || password.isEmpty || confirmPassword.isEmpty) {
                              setState(() {
                                messageError = "Please fill all the fields";
                              });
                              return;
                            }

                            if (password.length < 6) {
                              setState(() {
                                messageError = "Password must be at least 6 characters";
                              });
                              return;
                            }

                            if (password != confirmPassword) {
                              setState(() {
                                messageError = "Passwords do not match";
                              });
                              return;
                            }

                            try {
                              final newUser = await _auth.createUserWithEmailAndPassword(
                                email: email.trim(),
                                password: password,
                              );
                              if (newUser.user != null) {
                                Navigator.pushNamed(context,LoadingScreen.id);
                              } else {
                                setState(() {
                                  messageError = "Unexpected error. Try again.";
                                });
                              }
                            } catch (e) {
                              setState(() {
                                messageError = "This email is already registered.";
                              });
                            }
                            setState(() {
                              showSpinner=false;
                            });
                          }
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Already have an account?",
                          style: TextStyle(
                            color: Colors.white
                          ),),
                          CustomButton(
                              height:50.0,
                              width: 70.0,
                              text: "Log In",
                              colour: [Colors.black, Colors.black],
                              colorText: Colors.white,

                              onPressed:()=>Navigator.pushNamed((context), LogInScreen.id),
                          ),
                        ],
                      )

                    ],

                  ),
                )
            ),
          ),


      ),
    );
  }
}




