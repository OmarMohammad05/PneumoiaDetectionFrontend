import 'package:flutter/material.dart';
import 'dart:math';

class SensorDataProvider extends ChangeNotifier {

  int? oxygenLevel;
  double? temperature;

  final List<int> o2 = [95, 96 , 97 , 98 , 99 , 100];
  final Random random = Random();

  Future<void> fetchSensorData() async {
    await Future.delayed(const Duration(seconds: 2));

    oxygenLevel = o2[random.nextInt(o2.length)];
    temperature = 36.0 + random.nextDouble() * 2.5;  //  36.0 to  38.5
    notifyListeners();
  }
}
