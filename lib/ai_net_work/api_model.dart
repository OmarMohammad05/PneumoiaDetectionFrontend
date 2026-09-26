import 'dart:convert';
import 'package:http/http.dart' as http;

Future<String> sendPatientData({
  required int age,
  required double oxygen,
  required double temperature,
  required int genderF,
  required int genderM,
  required int coughBloody,
  required int coughDry,
  required int coughWet,
  required int chestPainYes,
  required int chestPainNo,
  required int vomitingYes,
  required int vomitingNo,
  required int painYes,
  required int painNo,
}) async {
  final url = Uri.parse('https://aibackendjsyp.onrender.com/predict');
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "Age": age,
      "Oxygen_saturation": oxygen,
      "Temperature": temperature,
      "Gender_F": genderF,
      "Gender_M": genderM,
      "Cough_Bloody": coughBloody,
      "Cough_Dry": coughDry,
      "Cough_Wet": coughWet,
      "ChestPain_Yes": chestPainYes,
      "ChestPain_No": chestPainNo,
      "Vomiting_Yes": vomitingYes,
      "Vomiting_No": vomitingNo,
      "Pain_Yes": painYes,
      "Pain_No": painNo,
    }),
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = jsonDecode(response.body);
    if (data.containsKey('prediction')) {
      return data['prediction'].toString();
    } else if (data.containsKey('error')) {
      return 'Error: ${data['error']}';
    } else {
      return 'Unexpected response';
    }
  } else {
    return 'Server error: ${response.statusCode}';
  }
}
