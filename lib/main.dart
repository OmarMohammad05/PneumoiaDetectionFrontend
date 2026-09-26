import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'screens/sign_in.dart';
import 'screens/sign_up.dart';
import 'accounts/patients_screen.dart';
import 'accounts/patients_info.dart';
import 'screens/loading_screen.dart';
import 'package:provider/provider.dart';
import 'ai_net_work/sensor_data.dart';
import 'accounts/data_patients.dart';
import 'screens/welcomeScreen.dart';
void main()  async{
  WidgetsFlutterBinding.ensureInitialized();  // Initialized of database.
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SensorDataProvider(),
        ),
      ],
      child: BreathX(),
    )

  );

}

class BreathX extends StatelessWidget {
  const BreathX({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // delete debug
      initialRoute: WelcomeScreen.id,
      routes:{
        WelcomeScreen.id:(context)=>WelcomeScreen(),
        SignUpScreen.id : (context)=>SignUpScreen(),
        LogInScreen.id: (context)=>LogInScreen(),
        LoadingScreen.id:(context)=>LoadingScreen(),
        //PatientsInfo.id: (context)=> PatientsInfo(),
        DataPatients.id:(context)=>DataPatients(),
        PatientsScreen.id : (context) => PatientsScreen(),

      },
    );
  }
}
