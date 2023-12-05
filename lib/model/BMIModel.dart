class BMIModel {
  double weight;
  double height;
  String gender;

  BMIModel({required this.weight, required this.height, required this.gender});

  double calculateBMI() {
    // Convert height to meters (from centimeters)
    double heightInMeters = height / 100.0;
    return weight / (heightInMeters * heightInMeters);
  }

  String getBMIStatus() {
    double bmi = calculateBMI();
    if (gender == 'Male') {
      if (bmi < 18.5) {
        return "Underweight! Careful during strong wind!";
      } else if (bmi >= 18.5 && bmi < 25) {
        return "That's ideal! Please maintain.";
      } else if (bmi >= 25 && bmi < 30) {
        return "Overweight! Work out please.";
      } else {
        return "Whoa Obese! Dangerous mate!";
      }
    } else if (gender == 'Female') {
      if (bmi < 16) {
        return "Underweight! Careful during strong wind!";
      } else if (bmi >= 16 && bmi < 22) {
        return "That's ideal! Please maintain.";
      } else if (bmi >= 22 && bmi < 27) {
        return "Overweight! Work out please.";
      } else {
        return "Whoa Obese! Dangerous mate!";
      }
    } else {
      // Handle other genders if needed
      return "Unknown gender";
    }
  }
}
