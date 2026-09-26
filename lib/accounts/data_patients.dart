import 'package:flutter/material.dart';
import 'package:breathe_x/constants.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:breathe_x/components/customButton.dart';
import 'package:breathe_x/ai_net_work/sensor_data.dart';
import 'package:breathe_x/screens/ai_loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breathe_x/ai_net_work/api_model.dart';


class DataPatients extends StatefulWidget {
  static const  String id='DataPatients';
  const DataPatients({super.key});

  @override
  State<DataPatients> createState() => _DataPatientsState();
}

class _DataPatientsState extends State<DataPatients> {
  final TextEditingController nameController =TextEditingController();
  final TextEditingController ageController=TextEditingController();
  final TextEditingController phoneController=TextEditingController();
    bool ?fastBreathing;
    bool ?confusion;
    bool ?smoker;
    String ?breathingSeverity;
    String ?coughType;
    String ?sputumColor;
    String ?chestPainSeverity;
    String ?fatigueSeverity;
    String ? sex;
    String ?numPhone;
    String ?fullName;
    String ? age;
    @override
    @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() =>
        Provider.of<SensorDataProvider>(context, listen: false).fetchSensorData());
  }
  void dispose() {
    // TODO: implement dispose
      nameController.dispose(); // For deleting data in memory
      ageController.dispose();
      phoneController.dispose();
       super.dispose();
  }
    void restData(){
      setState(() {
        nameController.clear();
        ageController.clear();
        phoneController.clear();
        fastBreathing=null;
        confusion=null;
        smoker=null;
        breathingSeverity=null;
        coughType=null;
        sputumColor=null;
        chestPainSeverity=null;
        fatigueSeverity=null;
        sex=null;
        numPhone=null;
        fullName=null;
        age=null;
      });
    }
  Future<void> applyFilter() async {
    final sensorData = Provider.of<SensorDataProvider>(context, listen: false);

    final int age = int.tryParse(ageController.text) ?? 25;
    final double temperature = sensorData.temperature ?? 36.5;
    final double oxygen = sensorData.oxygenLevel?.toDouble() ?? 95.0;

    int genderF = (sex == "Female") ? 1 : 0;
    int genderM = (sex == "Male") ? 1 : 0;


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

  Widget _buildDropdown(
       String label ,
       String ? value,
       Icon icon,
       List<String> items ,
       Function(String?) onChange){
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Padding(
             padding:const EdgeInsets.symmetric(horizontal: 12.0),
           child:Text(label,
             style: const TextStyle(
                 fontWeight: FontWeight.bold,
               color: Colors.white,
             ),
           ),
         ),
         const SizedBox(height: 6),
         DropdownButtonFormField<String>(
           dropdownColor: Colors.grey[700],
           style: TextStyle(
             color: Colors.white
           ),

           value: value,
           isExpanded: true,
           decoration:kTextField.copyWith(
             prefixIcon: icon,
               hintText: "",

           ),
           icon: Icon(Icons.arrow_drop_down),
           onChanged: onChange,
           items: items.map<DropdownMenuItem<String>>((String selectedValue)
           {
             return DropdownMenuItem<String>(
               value: selectedValue,
               child: Text(selectedValue),
             );
           }).toList(),
         ),
       ],
     );
   }
   Widget _buildBoolSelected(String question, bool ?value , Function(bool?)onChanged ){
     return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
       children: [
         Padding(padding:const EdgeInsets.symmetric(horizontal: 12.0),
         child:Text(
           question,
           style: const TextStyle(
             fontWeight: FontWeight.bold,
             color: Colors.white
         ),
         )
         ),
         Row(
           children: [
             const SizedBox(height: 6),
             Expanded(
                 child:RadioListTile<bool>(
                   title: Text("Yes",
                   style: TextStyle(
                     color: Colors.white
                   ),),
                   value: true,
                   groupValue: value,
                   onChanged: onChanged,
                   activeColor: Colors.white,
                 ),
             ),
             const SizedBox(height: 12.0,),
             Expanded(
                 child:RadioListTile<bool>(
                     title: Text("No",
                     style: TextStyle(
                       color:Colors.white
                     ),
                     ),
                     value: false,
                     groupValue: value,
                     activeColor: Colors.white,
                     onChanged:onChanged
                 )
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
      body: kStack(
         SafeArea(
            child:ListView(
              children:<Widget> [
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    "Medical Information",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.0,
                      fontWeight: FontWeight.bold

                    ),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                    color: Colors.white
                  ),
                  controller: nameController,
                  decoration:kTextField.copyWith(

                    hintText: "Full Name",
                    prefixIcon: Icon(FontAwesomeIcons.user,
                    color: Colors.white60,
                      size: 20.0,
                    ),
                    hintStyle: TextStyle(
                      color: Colors.white70
                    )
                  ) ,
                  onChanged: (valName){
                    setState(() {
                      fullName=valName;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ageController,
                  style: TextStyle(
                      color: Colors.white,

                  ),
                  decoration: kTextField.copyWith(
                    hintText: "Age",
                      prefixIcon: Icon(
                        FontAwesomeIcons.calendar,
                        color: Colors.white60,
                        size: 20.0,
                      ),
                      hintStyle: TextStyle(
                      color: Colors.white70
                  )
                  ),
                  onChanged: (valAge){
                    setState(() {
                      age=valAge;
                    });
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  style: TextStyle(
                      color: Colors.white
                  ),
                  controller: phoneController,
                  decoration: kTextField.copyWith(
                    prefixIcon: Icon(FontAwesomeIcons.phone,
                      color: Colors.white60,
                      size: 20.0,
                    ),
                    hintText: "Phone Number",
                      hintStyle: TextStyle(
                          color: Colors.white70
                      )
                  ),
                  onChanged: (valPhone){
                    setState(() {
                      numPhone=valPhone;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children:<Widget> [
                    Expanded(
                      child: Card(
                        color: Colors.grey[900],
                        child: Row(
                          children: [
                            Icon(FontAwesomeIcons.lungs,
                            color: Colors.white60,
                              size: 20.0,
                            ),
                            Column(
                              children:<Widget> [
                                Text(
                                  "       Oxygen",
                                  style: TextStyle(
                                  color: Color(0xFFAFAFB2)
                                ),
                                ),
                                Text("${sensorData.oxygenLevel}",
                                    style: TextStyle(
                                        color: Color(0xFFAFAFB2)
                                    )
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),

                    Expanded(
                        child: Card(
                          color: Colors.grey[900],
                          child: Row(
                            children: [
                              Icon(
                                FontAwesomeIcons.thermometerHalf,
                              color: Colors.white60,
                                size: 20.0,
                              ),
                              Column(
                                children:<Widget> [
                                  Text("Temperature",
                                      style: TextStyle(
                                          color: Color(0xFFAFAFB2)
                                      )
                                  ),
                                  Text("${sensorData.temperature?.toStringAsFixed(1)}°C",
                                      style: TextStyle(
                                          color: Color(0xFFAFAFB2)
                                      )
                                  ),
                                ],
                              ),
                            ],
                          ),
                    ),
                    )
                  ],
                ),
                const SizedBox(height: 12),
                _buildDropdown("Gender",
                    sex,
                    Icon(FontAwesomeIcons.venusMars,
                    color: Colors.white60,
                      size: 20.0,
                    ),
                    ["Male", "Female"],
                        (choseVal)=>setState(() {sex=choseVal!;})
                ),
                const SizedBox(height: 12),
                _buildDropdown(
                    "Breathing Severity",
                    breathingSeverity,
                    Icon(FontAwesomeIcons.lungs,color: Colors.white60,size: 20.0,),
                    ["None", "Mild", "Moderate", "Severe"],
                        (choseValue)=>setState(() {breathingSeverity=choseValue!;})),
                const SizedBox(height: 12),
                _buildDropdown(
                    "Cough type",
                    coughType,
                    Icon(FontAwesomeIcons.headSideCough,color: Colors.white60,size: 20.0,),
                    ["None", "Dry", "Wet", "Bloody"],
                        (choseValue)=>setState((){coughType=choseValue!;})),
                const SizedBox(height: 12),
                _buildDropdown(
                    "Sputum Color ",
                    sputumColor,
                    Icon(FontAwesomeIcons.palette,color: Colors.white60,size: 20.0,),
                    ["None", "Clear", "Green", "Yellow", "Mixed with blood"],
                        (choseValue)=>setState(() {sputumColor=choseValue!;})),
                const SizedBox(height: 12),
                _buildDropdown(
                    "Chest Pain Severity",
                    chestPainSeverity,
                    Icon(FontAwesomeIcons.heart,color: Colors.white60,size: 20.0,),
                    ["None", "Mild", "Moderate", "Severe"],
                        (choseValue) => setState(() => chestPainSeverity = choseValue!)),
                _buildDropdown(
                    "Fatigue Severity",
                    fatigueSeverity,
                    Icon(FontAwesomeIcons.batteryQuarter,color: Colors.white60,size: 20.0,),
                    ["None", "Mild", "Moderate", "Severe"],
                        (choseValue) {setState(() => fatigueSeverity = choseValue!);}),
                const SizedBox(height: 12),
                _buildBoolSelected(
                    "Faster Breathing than Normal?",
                    fastBreathing,
                        (val)=>setState(() {fastBreathing=val!;})),
                const SizedBox(height: 12,),
                _buildBoolSelected(
                    "Do you experience confusion or difficulty concentrating?",
                    confusion,
                    (val)=>setState(() {confusion=val!;})),
                const SizedBox(height: 12,),
                _buildBoolSelected("Are you a smoker?",
                    smoker,
                    (val)=>setState(() {smoker=val!;})),
                const SizedBox(height: 20,),
                Row(
                  children: [
                    CustomButton(
                      text: "Apply AI",
                        height: 50.0,
                        width: 120.0,
                        onPressed: (){
                          applyFilter();
                        }),
                    CustomButton(
                        text: "Reset",
                        height: 50.0,
                        width: 120,
                        colour: [Colors.grey,Colors.white70],
                        onPressed: (){
                          restData();
                        }),
                  ],
                ),
                SizedBox(height: 15.0,)
           ]
            ),
        ),
      ),
    );
  }
}
