import 'package:breathe_x/accounts/patients_screen.dart';
import 'package:flutter/material.dart';
import 'package:breathe_x/constants.dart';
import 'package:breathe_x/components/customButton.dart';
import 'package:modal_progress_hud_alt/modal_progress_hud_alt.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breathe_x/accounts/patients_info.dart';
import 'package:breathe_x/screens/loading_screen.dart';
import 'sign_up.dart';
class LogInScreen extends StatefulWidget {
  const LogInScreen({super.key});
  static const String id= 'LogInScreen';

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}
class _LogInScreenState extends State<LogInScreen> {
  final _auth= FirebaseAuth.instance;
  UserCredential? currentUser;
  late String email;
  late String password;
  bool _isHidden=true;
  bool showSpinner=false;
  String ? messageError;
  @override
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
                padding: const EdgeInsets.symmetric(vertical: 100.0 ,horizontal: 10.0),
                child: ListView(
                  children:<Widget> [
                    SizedBox(height:110.0,),
                    Center(
                      child: Text("Welcome back",
                        style: TextStyle(
                            color: Colors.white,
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(height: 30.0,),
                    TextField(
                      style: TextStyle(
                          color: Colors.white
                      ),
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration:kTextField.copyWith(
                        hintText: "Enter your email",
                        prefixIcon: Icon(Icons.email)
                      ),
                      onChanged: (value){
                        email=value.trim();
                      },
                    ),
                    SizedBox(height: 18.0,),
                    TextField(
                      style: TextStyle(
                        color: Colors.white
                      ),
                      obscureText: _isHidden,
                      textAlign: TextAlign.center,
                      decoration: kTextField.copyWith(
                          hintText: "Enter your password",
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon:IconButton(onPressed: (){
                            setState(() {
                              _isHidden = !_isHidden;
                            });
                          },
                          icon: Icon(_isHidden ? Icons.visibility_off:Icons.visibility),
                          color: Colors.white70,)
                      ),
                      onChanged: (value){
                        password=value;
                      },
                    ),
                    SizedBox(height: 20.0,),
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
                       text:"Log in ",
                        onPressed: () async {
                         setState(() {
                           messageError=null;
                         });
                         if (email.isEmpty || password.isEmpty) {
                           setState(() {
                             messageError = 'Please enter your email and password';
                           });
                           return;
                         }
                         setState(() {
                           showSpinner = true;
                         });
         
                         try{
                            currentUser=await _auth.signInWithEmailAndPassword(email: email, password: password);
                            if(currentUser != null){
                              Navigator.pushNamed(context, LoadingScreen.id);
                            }
                         }on FirebaseAuthException catch(e){
                           messageError="Do not have account";
                           if (e.code == 'user-not-found') {
                             setState(() {
                               messageError = 'No account found for that email.';
                             });
                           } else if (e.code == 'wrong-password') {
                             setState(() {
                               messageError = 'Incorrect password.';
                             });
                           } else if (e.code == 'invalid-email') {
                             setState(() {
                               messageError = 'Invalid email address.';
                             });
                           } else {
                             setState(() {
                               messageError = 'An error occurred: ${e.message}';
                             });
                           }
                         }
                         catch(e){
                           setState(() {
                             messageError = 'An unexpected error occurred.';
                           });
                         }finally{
                           setState(() {
                             showSpinner=false;
                           });
         
                        }
         
                        }),
                    SizedBox(height: 12.0,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:<Widget> [
                        Text("Don’t have an account?",style: TextStyle(color: Colors.white),),
                        CustomButton(
                          text: "Sign up",
                            height: 70.0,
                            width: 80.0,
                            colorText: Colors.white,
                            colour: [Colors.black,Colors.black],
                            onPressed:()=>Navigator.pushNamed((context), SignUpScreen.id)),
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
