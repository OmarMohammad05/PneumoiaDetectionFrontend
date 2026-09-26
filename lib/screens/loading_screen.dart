import 'package:flutter/material.dart';
import 'dart:async';
import 'package:breathe_x/accounts/patients_info.dart';
import 'package:breathe_x/accounts/data_patients.dart';

class LoadingScreen extends StatefulWidget {
  static const id = 'LoadingScreen';
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  double? temperature;
  int? oxygen;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // إعداد الحركة المتدرجة للأيقونة
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _simulateSensorData();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _simulateSensorData() async {
    await Future.delayed(const Duration(seconds: 3)); // محاكاة تأخير السنسور
    setState(() {
      oxygen = 95;
      temperature = 37.2;
    });
    Navigator.pushNamed(context, DataPatients.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900], // داكن متناسق مع السكرينز السابقة
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // أيقونة الجهاز متحركة
            ScaleTransition(
              scale: _animation,
              child: Icon(
                Icons.devices, // أيقونة الجهاز
                size: 80,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 25),
            // نص أساسي
            const Text(
              "Device is currently disconnected — displaying static data for testing purposes",
              //"Receiving data from the device...",
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            // نص صغير إضافي
            // Text(
            //   "Please wait a moment",
            //   style: TextStyle(
            //     color: Colors.grey[500],
            //     fontSize: 14,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
          ],
        ),
      ),
    );
  }
}
