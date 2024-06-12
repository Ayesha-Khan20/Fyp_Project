import 'dart:convert';
//import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:health/health.dart';
import 'package:http/http.dart' as http;
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../screens/profile_screen.dart';
//import '../screens/welcome_screen.dart';
//import '../screens/user_screen.dart';

class Prediction extends StatefulWidget {
 

  const Prediction(this.temp, this.steps, {super.key});
  final HealthValue temp;
  final int steps;

  @override
  State<Prediction> createState() => _PredictionState();
}

class _PredictionState extends State<Prediction> {
  TextEditingController temperature = TextEditingController();
  TextEditingController step_cnt = TextEditingController();

 int? z;

  Future<int> MLdata(double a, int b) async {
    final response = await http.post(
      Uri.parse('https://stressdetectorhack36.onrender.com/predict'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode([
        {"C": a, "Step count": b}
      ]),
    );

    if (response.statusCode == 200) {
      var x = jsonDecode(response.body);
      return x['prediction'][0];
    } else {
      throw Exception('Failed to fetch ML Data.');
    }
  }

  bool editingEnabled = true;

  @override
  void initState() {
    // TODO: implement initState
    // temperature.text = widget.temp.toString();
    temperature.text = widget.temp.toString();

    step_cnt.text = widget.steps.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Smart Stress Prediction'),
        centerTitle: true,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextsField("Temperature (centigrade)", '', temperature, false),
              TextsField("Step count (last 10 min)", '', step_cnt, false),
              const SizedBox(height: 20),
              SizedBox(
                height: 250,
                child: z != null
                    ? CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 13.0,
                        animation: true,
                        animationDuration: 600,
                        percent: z == 0
                            ? 0.3
                            : z == 1
                                ? 0.6
                                : 0.9,
                        center: z == 0
                            ? const Text('Low Stress')
                            : z == 1
                                ? const Text('Normal Stress')
                                : const Text('High Stress'),
                        circularStrokeCap: CircularStrokeCap.round,
                        progressColor: z == 0
                            ? Colors.green
                            : z == 1
                                ? Colors.orange
                                : Colors.red,
                      )
                    : Container(
                        height: 250,
                        padding: const EdgeInsets.all(20),
                        child: const Image(
                          image: AssetImage('assets/images/robo.gif'),
                        ),
                      ),
              ),
              Container(
                padding: EdgeInsets.fromLTRB(
                    width / 15, height / 20, width / 15, height / 20),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      color: Colors.redAccent.withOpacity(0.8),
                      borderRadius: const BorderRadius.all(Radius.circular(15.0))),
                  child: MaterialButton(
                      elevation: 10.00,
                      minWidth: width / 1.2,
                      height: height / 11.5,
                      onPressed: () 
                      async
                       {
                        // int x = await MLdata(
                        //     (double.parse(widget.temp.toString()) * 9 / 5 + 32),
                        //     widget.steps);
                        // setState(() {
                        //   editingEnabled = !editingEnabled;
                        //   z = x;
                        // });
                        int? x = await MLdata((double.parse(widget.temp.toString()) * 9 / 5 + 32), widget.steps);
setState(() {
                          editingEnabled = !editingEnabled;
                          z = x;
                        });
                      },
                      child: const Text(
                        'Predict',
                        style: TextStyle(color: Colors.white, fontSize: 20.00),
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}