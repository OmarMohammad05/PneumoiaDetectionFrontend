import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:breathe_x/ai_net_work/sensor_data.dart';
import 'package:breathe_x/ai_net_work/api_model.dart';
import 'package:breathe_x/screens/ai_loading_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientsInfo extends StatefulWidget {
  static const String id = "PatientsInfo";
  @override
  State<PatientsInfo> createState() => _PatientsInfoState();
}

class _PatientsInfoState extends State<PatientsInfo> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController noteController = TextEditingController();
  final _firestore=FirebaseFirestore.instance;

  String? breathingSeverity;
  String? coughType;
  String? sputumColor;
  String? chestPainSeverity;
  String? fatigueSeverity;
  bool? fastBreathing;
  bool? confusion;
  bool? smoker;

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<SensorDataProvider>(context, listen: false).fetchSensorData());
  }

  @override
  void dispose() {
    fullNameController.dispose();
    ageController.dispose();
    phoneController.dispose();
    noteController.dispose();
    super.dispose();
  }

  Future<void> applyFilter() async {
    final sensorData = Provider.of<SensorDataProvider>(context, listen: false);

    final int age = int.tryParse(ageController.text) ?? 25;
    final double temperature = sensorData.temperature ?? 36.5;
    final double oxygen = sensorData.oxygenLevel?.toDouble() ?? 95.0;

    int genderF = 1;
    int genderM = 0;

    int coughBloody = (coughType == "Bloody") ? 1 : 0;
    int coughDry = (coughType == "Dry") ? 1 : 0;
    int coughWet = (coughType == "Wet") ? 1 : 0;

    int chestPainYes = (chestPainSeverity != null && chestPainSeverity != "None") ? 1 : 0;
    int chestPainNo = (chestPainSeverity == null || chestPainSeverity == "None") ? 1 : 0;

    int vomitingYes = 0;
    int vomitingNo = 1;

    int painYes = 0;
    int painNo = 1;

    try {
      final prediction = await sendPatientData(
        age: age,
        oxygen: oxygen,
        temperature: temperature,
        genderF: genderF,
        genderM: genderM,
        coughBloody: coughBloody,
        coughDry: coughDry,
        coughWet: coughWet,
        chestPainYes: chestPainYes,
        chestPainNo: chestPainNo,
        vomitingYes: vomitingYes,
        vomitingNo: vomitingNo,
        painYes: painYes,
        painNo: painNo,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>AILoadingScreen(prediction: prediction),
        ),
      );
      //_firestore.collection('dataPatients').add(prediction as Map<String, dynamic>);

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending data: $e')),
      );
    }
  }


  void resetFilter() {
    fullNameController.clear();
    ageController.clear();
    phoneController.clear();
    noteController.clear();
    setState(() {
      breathingSeverity = null;
      coughType = null;
      sputumColor = null;
      chestPainSeverity = null;
      fatigueSeverity = null;
      fastBreathing = null;
      confusion = null;
      smoker = null;
    });
  }

  Widget _buildDropdown(String label, String? value, List<String> options, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: value,
          isExpanded: true,
          decoration: const InputDecoration(border: OutlineInputBorder()),
          items: options.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildBoolSelector(String label, bool? value, Function(bool?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Row(
          children: [
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("Yes"),
                value: true,
                groupValue: value,
                onChanged: onChanged,
              ),
            ),
            Expanded(
              child: RadioListTile<bool>(
                title: const Text("No"),
                value: false,
                groupValue: value,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final sensorData = Provider.of<SensorDataProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Medical Information",
        style: TextStyle(
          color: Colors.white,
          fontSize: 23.0
        ),),
        backgroundColor:Color(0xFF4CAF50),
        elevation: 10,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: fullNameController,
              decoration: const InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: Colors.blue.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text('Oxygen Level', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(sensorData.oxygenLevel?.toString() ?? '--'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Card(
                    color: Colors.green.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [
                          const Text('Temperature', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(sensorData.temperature?.toStringAsFixed(1) ?? '--'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildDropdown("Breathing Severity", breathingSeverity, ["None", "Mild", "Moderate", "Severe"], (val) {
              setState(() => breathingSeverity = val);
            }),
            const SizedBox(height: 12),
            _buildDropdown("Cough Type", coughType, ["None", "Dry", "Wet", "Bloody"], (val) {
              setState(() => coughType = val);
            }),
            const SizedBox(height: 12),
            _buildDropdown("Sputum Color", sputumColor, ["None", "Clear", "Green", "Yellow", "Mixed with blood"], (val) {
              setState(() => sputumColor = val);
            }),
            const SizedBox(height: 12),
            _buildDropdown("Chest Pain Severity", chestPainSeverity, ["None", "Mild", "Moderate", "Severe"], (val) {
              setState(() => chestPainSeverity = val);
            }),
            const SizedBox(height: 12),
            _buildDropdown("Fatigue Severity", fatigueSeverity, ["None", "Mild", "Moderate", "Severe"], (val) {
              setState(() => fatigueSeverity = val);
            }),
            const SizedBox(height: 12),
            _buildBoolSelector("Faster Breathing than Normal?", fastBreathing, (val) {
              setState(() => fastBreathing = val);
            }),
            const SizedBox(height: 12),
            _buildBoolSelector("Do you experience confusion or difficulty concentrating", confusion, (val) {
              setState(() => confusion = val);
            }),
            const SizedBox(height: 12),
            _buildBoolSelector("Are you a smoker?", smoker, (val) {
              setState(() => smoker = val);
            }),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: applyFilter,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    child: const Text("Apply Filter"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: resetFilter,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Reset"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
