import 'package:flutter/material.dart';

class Instruction extends StatefulWidget {
  const Instruction({Key? key}) : super(key: key);

  @override
  State<Instruction> createState() => _InstructionState();
}

class _InstructionState extends State<Instruction> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Instructions'),
        centerTitle: true,
        backgroundColor:const Color.fromARGB(255, 43, 193, 178),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(15),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Here are the steps to connect a wearable device to Google Fit on your phone:',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        fontSize: 15),
                  ),
                  // Text(
                  //     '1. Ensure that your wearable device is compatible with Google Fit. Check the list of supported devices on the Google Fit website.'),
                  Text(
                      '1. Install the Google Fit app on your phone from the Google Play Store.'),
                  // Text(
                  //     '3. Turn on Bluetooth on both your phone and the wearable device.'),
                  Text(
                      '2. Open the Google Fit app on your phone and tap on vitals option.'),
                  Text('3. Select the requried option for tracking'),
                  Text(
                      '4.Add your specific data rates to the Google fit App'),
                  Text(
                      '5. Save the following rates to the Google Fit App'),
                  Text(
                    'Once your device is connected, it should automatically sync with Google Fit.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Note: The specific steps may vary slightly depending on the type of wearable device you are using.',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 15, color:Color.fromARGB(255, 43, 193, 178),),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}