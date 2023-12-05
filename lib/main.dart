import 'package:flutter/material.dart';
import 'controller/BMIController.dart';
import 'controller/SQLite.controller.dart';

void main() {
  runApp(MaterialApp(
    title: 'BMI Calculator',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    home: BMIView(),
  ));
}

class BMIView extends StatefulWidget {
  @override
  _BMIViewState createState() => _BMIViewState();
}

class _BMIViewState extends State<BMIView> {
  final BMIController bmiController = BMIController();
  final SQLiteController sqliteController = SQLiteController();

  double averageBMIMale = 0.0;
  double averageBMIFemale = 0.0;
  int countMale = 0;
  int countFemale = 0;

  @override
  void initState() {
    super.initState();
    loadPreviousData();
    loadStatistics();
  }

  void loadPreviousData() async {
    await bmiController.loadPreviousData(sqliteController);
    if (mounted) {
      setState(() {});
    }
  }

  void loadStatistics() async {
    averageBMIMale = await sqliteController.calculateAverageBMI('Male');
    averageBMIFemale = await sqliteController.calculateAverageBMI('Female');
    countMale = await sqliteController.countGender('Male');
    countFemale = await sqliteController.countGender('Female');
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BMI Calculator")),
      body: BMICalculatorWidget(
        bmiController: bmiController,
        sqliteController: sqliteController,
        averageBMIMale: averageBMIMale,
        averageBMIFemale: averageBMIFemale,
        countMale: countMale,
        countFemale: countFemale,
        onCalculate: () {
          loadStatistics();
          if (mounted) {
            setState(() {});
          }
        },
      ),
    );
  }
}

class BMICalculatorWidget extends StatefulWidget {
  final BMIController bmiController;
  final SQLiteController sqliteController;
  final double averageBMIMale;
  final double averageBMIFemale;
  final int countMale;
  final int countFemale;
  final VoidCallback? onCalculate;

  BMICalculatorWidget({
    required this.bmiController,
    required this.sqliteController,
    required this.averageBMIMale,
    required this.averageBMIFemale,
    required this.countMale,
    required this.countFemale,
    this.onCalculate,
  });

  @override
  _BMICalculatorWidgetState createState() => _BMICalculatorWidgetState();
}

class _BMICalculatorWidgetState extends State<BMICalculatorWidget> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.bmiController.fullNameController,
              decoration: InputDecoration(
                labelText: 'Full Name',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.bmiController.weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget.bmiController.heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
              ),
            ),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Gender: '),
              Radio<String>(
                value: 'Male',
                groupValue: widget.bmiController.gender,
                onChanged: (String? value) {
                  setState(() {
                    widget.bmiController.setGender(value);
                  });
                },
              ),
              Text('Male'),
              Radio<String>(
                value: 'Female',
                groupValue: widget.bmiController.gender,
                onChanged: (String? value) {
                  setState(() {
                    widget.bmiController.setGender(value);
                  });
                },
              ),
              Text('Female'),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              widget.bmiController.calculateBMI();
              widget.sqliteController.insertBMIRecord(widget.bmiController);
              if (widget.onCalculate != null) {
                widget.onCalculate!();
              }
            },
            child: Text('Calculate'),
          ),
          SizedBox(height: 20),
          Text('BMI Result: ${widget.bmiController.bmiResult}'),
          Text('BMI Status: ${widget.bmiController.bmiStatus}'),
          SizedBox(height: 20),
          Text('Average BMI for Males: ${widget.averageBMIMale.toStringAsFixed(2)}'),
          Text('Average BMI for Females: ${widget.averageBMIFemale.toStringAsFixed(2)}'),
          Text('Total Male records: ${widget.countMale}'),
          Text('Total Female records: ${widget.countFemale}'),
        ],
      ),
    );
  }
}
