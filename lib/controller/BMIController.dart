import 'package:flutter/material.dart';
import '../model/BMIModel.dart';
import 'SQLite.controller.dart';

class BMIController {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  String gender = 'Male';
  String bmiResult = "";
  String bmiStatus = "";

  // Sets the gender based on the user's choice
  void setGender(String? value) {
    if (value != null) {
      gender = value;
    }
  }

  // Calculates the BMI using the BMIModel
  void calculateBMI() {
    final double weight = double.parse(weightController.text);
    final double height = double.parse(heightController.text);
    final bmiModel = BMIModel(weight: weight, height: height, gender: gender);

    bmiResult = bmiModel.calculateBMI().toStringAsFixed(2);
    bmiStatus = bmiModel.getBMIStatus();
  }

  // Loads the most recent data from the SQLite database
  Future<void> loadPreviousData(SQLiteController sqliteController) async {
    final data = await sqliteController.getPreviousData();
    if (data != null) {
      fullNameController.text = data['fullname'];
      weightController.text = data['weight'].toString();
      heightController.text = data['height'].toString();
      setGender(data['gender']);
      bmiResult = data['bmi'].toString();
      bmiStatus = data['status'];
    }
  }
}
