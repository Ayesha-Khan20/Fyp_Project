import 'dart:async';
import 'dart:convert';

import 'package:health/health.dart';
import 'package:mental_health_app/modals/helpline.dart';
import 'package:mental_health_app/side_bar/assessment.dart';
import '../modals/predict.dart';

import '../main.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'package:usage_stats/usage_stats.dart';

import '../modals/introduction.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high importance channel', 'High Importance Notifications',
    description: 'This Channel is used for important notifications',
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class UserData extends StatefulWidget {
  const UserData({Key? key}) : super(key: key);

  @override
  State<UserData> createState() => _UserDataState();
}

bool run = true;
int? _steps = 0;
int? stepx = 0;
String? _heart_rate;
HealthValue? _bp_d;
HealthValue? _bp_s;
HealthValue? _oxygen;
HealthValue ?_bodytemp ;
int c = 0;

class _UserDataState extends State<UserData> {
  List<EventUsageInfo> events = [];
   Map<String?, NetworkInfo?> _netInfoMap = {};

  bool notify = false;

  Future func() async {
    HealthFactory health = HealthFactory();

    // define the types to get
    var types = [
      HealthDataType.STEPS,
      HealthDataType.HEART_RATE,
     HealthDataType.BLOOD_GLUCOSE,
     HealthDataType.BLOOD_PRESSURE_DIASTOLIC,
     HealthDataType.BLOOD_PRESSURE_SYSTOLIC,
      HealthDataType.BLOOD_OXYGEN,
      HealthDataType.BODY_TEMPERATURE
    ];

    await Permission.activityRecognition.request();

    //requesting access to the data types before reading them
     bool requested = await health.requestAuthorization(types);

    var now = DateTime.now();
    // fetch health data from the last 24 hours
    List<HealthDataPoint> healthData = await health.getHealthDataFromTypes(
        now.subtract(const Duration(days: 1)), now, types);

    // get the number of steps for today
    var midnight = DateTime(now.year, now.month, now.day);
    var xyz = DateTime(now.year, now.month, now.day, now.hour, now.minute - 10);
    _steps = await health.getTotalStepsInInterval(midnight, now);
    stepx = await health.getTotalStepsInInterval(xyz, now);
    stepx ??= 0;

    String? heartRate;
    HealthValue? bpd;
    HealthValue? bps;
   HealthValue? oxygen;
    HealthValue? bodytemp;
    for (final data in healthData) {
      if (data.type == HealthDataType.HEART_RATE) {
        heartRate = "${data.value}";
            }
       if (data.type == HealthDataType.BLOOD_PRESSURE_DIASTOLIC) {
         bpd = data.value;
            }
      if (data.type == HealthDataType.BLOOD_PRESSURE_SYSTOLIC) {
        bps = data.value;
            }
       if (data.type == HealthDataType.BLOOD_OXYGEN) {
         oxygen = data.value;
             }
      if (data.type == HealthDataType.BODY_TEMPERATURE) {
        bodytemp = data.value;
            }
    }

    setState(() {
      _heart_rate = heartRate;
     _bp_d = bpd;
     _bp_s = bps;
      _oxygen = oxygen;
      _bodytemp = bodytemp;
    });
  }
//email from specialist
  Future sendEmail(
      String name1, String name2, String message, String email) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    const serviceId = 'service_vc1tc92';
    const templateId = 'template_mak408l';
    const userId = 'C7ns8WoNqX9Ns9GvG';
    try {
      final response = await http.post(url,
          headers: {
            'origin': 'http:localhost',
            'Content-Type': 'application/json'
          },
          body: json.encode({
            'service_id': serviceId,
            'template_id': templateId,
            'user_id': userId,
            'template_params': {
              'from_name': name1,
              'to_name': name2,
              'message': message,
              'to_email': email,
            }
          }));
      return response.statusCode;
    } catch (e) {
      print("feedback email response");
    }
  }

  void notification() async {
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    var x = events[1]
        .packageName!
        .replaceFirst("com.", "")
        .replaceFirst(".android", "");
    String statement = (x == 'whatsapp' ||
            x == 'instagram' ||
            x == 'snapchat' ||
            x == 'twitter' ||
            x == 'google.youtube')
        ? '4. Stop using $x'
        : '4. Stop using all the apps now.';

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    if (int.parse(_heart_rate!.split(".")[0]) > 100) {
      flutterLocalNotificationsPlugin.show(
        0,
        "Alert",
        "Your heartbeat is increasing",
        NotificationDetails(
          android: AndroidNotificationDetails(channel.id, channel.name,
              channelDescription: channel.description,
              importance: Importance.high,
              color: const Color.fromARGB(255, 144, 234, 150),
),
        ),
        payload: "optional payload",
      );
    }

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (NotificationResponse) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Alert',
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Anxiety attack detected!!',
                  style: TextStyle(fontSize: 15.00, color: Colors.blue),
                ),
                const SizedBox(height: 5),
                Text(
                  '1. Stop using your phone\n2. Take Deep breaths and Relax\n3. Take a Juice break\n$statement',
                  style: const TextStyle(fontSize: 15.00, color: Colors.black),
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            TextButton(
              child: Text('Call ${patientInfo.friendName}'),
              onPressed: () {
                FlutterPhoneDirectCaller.callNumber(patientInfo.phoneNo!);
              },
            ),
          ],
        ),
      );
    }, onDidReceiveBackgroundNotificationResponse: (NotificationResponse) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text(
            'Alert',
            style: TextStyle(
                fontSize: 20, color: Colors.red, fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 180,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Anxiety attack detected!!',
                  style: TextStyle(fontSize: 15.00, color: Colors.blue),
                ),
                const SizedBox(height: 5),
                Text(
                  '1. Stop using your phone\n2. Take Deep breaths and Relax\n3. Take a Juice break\n$statement',
                  style: const TextStyle(fontSize: 15.00, color: Colors.black),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            ),
            TextButton(
              child: Text('Call ${patientInfo.friendName}'),
              onPressed: () {
                FlutterPhoneDirectCaller.callNumber(patientInfo.phoneNo!);
              },
            ),
          ],
        ),
      );
    });
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = DateTime.now();
    DateTime startDate = endDate.subtract(const Duration(days: 1));

    List<EventUsageInfo> queryEvents =
        await UsageStats.queryEvents(startDate, endDate);
    List<NetworkInfo> networkInfos =
        await UsageStats.queryNetworkUsageStats(startDate, endDate);
    Map<String?, NetworkInfo?> netInfoMap = { for (var v in networkInfos) v.packageName : v };

    setState(() {
      events = queryEvents.reversed.toList();
      _netInfoMap = netInfoMap;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    if (run) {
      initUsage();
      func();
      setState(() {
        run = false;
      });
    }
    Timer.periodic(const Duration(minutes: 1), (timer) {
      func();
    });
    Timer.periodic(const Duration(minutes: 1), (timer) {
      notification();
      if (int.parse(_heart_rate!.split(".")[0]) > 100) {
        c = 1;
      }
    });
    Timer.periodic(const Duration(hours: 3), (timer) {
      if (c == 1) {
        sendEmail(
          patientInfo.name!,
          patientInfo.friendName!,
          'Your friend ${patientInfo.name} had an anxiety attack',
          patientInfo.friendContact!,
        );
        sendEmail(
          patientInfo.name!,
          patientInfo.specialistName!,
          'Your patient ${patientInfo.name} had an anxiety attack',
          patientInfo.specialistContact!,
        );
        c = 0;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('HOPE'),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 43, 193, 178),
         //backgroundColor: Colors.black,
        ),
        drawer: const Menu(),
        body: Container(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                        vertical: height / 40, horizontal: 0.04 * width),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Hey!! ${patientInfo.name}, Welcome to HOPE',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontStyle: FontStyle.italic,
                              color:  Color.fromARGB(255, 40, 143, 134),
                              fontSize: 15),
                        ),
                        const SizedBox()
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DataValue(
                        data: "$_heart_rate BPM",
                        dataIcon: FontAwesomeIcons.heartPulse,
                        dataName: "Heart rate",
                      ),
                      DataValue(
                        data: "$_bp_s mm Hg",
                        dataIcon: Icons.monitor_heart_outlined,
                        dataName: "Systolic BP",
                      ),
                    ],
                  ),
                  SizedBox(height: height / 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DataValue(
                        data: "$_bp_d mm Hg",
                        dataIcon: Icons.monitor_heart,
                        dataName: "Diastolic BP",
                      ),
                      DataValue(
                        data: "$_oxygen %",
                        dataIcon: Icons.bloodtype,
                        dataName: "Blood oxygen",
                      ),
                    ],
                  ),
                  SizedBox(height: height / 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      DataValue(
                        data: "$_bodytemp Centigrade",
                        dataIcon: Icons.thermostat,
                        dataName: "Temperature",
                      ),
                      DataValue(
                        data: "$_steps",
                        dataIcon: Icons.directions_walk,
                        dataName: "Steps (today)",
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
//class for data setup
class DataValue extends StatelessWidget {
  const DataValue(
      {super.key, required this.data, required this.dataName, required this.dataIcon});

  final String data;
  final String dataName;
  final IconData dataIcon;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Container(
      width: width / 2.3,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.grey[200]!.withOpacity(0.7)),
      child: Column(
        children: [
          Icon(dataIcon, size: 0.174 * width, color: const Color.fromARGB(255, 154, 27, 73)),
          SizedBox(height: height / 40),
          Text(
            dataName,
            style: TextStyle(
                fontSize: 0.036 * width,
                color:  const Color.fromARGB(255, 40, 143, 134),
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: height / 40),
          Text(data),
        ],
      ),
    );
  }
}
//side draw

class Menu extends StatefulWidget {
  const Menu({Key? key}) : super(key: key);

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    // var size = MediaQuery.of(context).size;
    // var height = size.height;
    // var width = size.width;
    Color color = const Color.fromARGB(255, 4, 198, 189);
    return Drawer(
      backgroundColor: Colors.white,
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 40, left: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.home,
                      color: Color.fromARGB(255, 40, 143, 134),
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Home',
                     textScaler:const TextScaler.linear(1) ,
                      style: TextStyle(fontSize: 25, color: color),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                       MaterialPageRoute(builder: (context) => const Assessment()
                      )
                  );
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      color: Color.fromARGB(255, 40, 143, 134),
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Self Assesment',
                     textScaler:const TextScaler.linear(1) ,
                      style: TextStyle(fontSize: 25, color: color),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                child: Row(
                  children: [
                    const Icon(
                      Icons.book_outlined,
                      color:  Color.fromARGB(255, 40, 143, 134),
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Instructions',
                     textScaler:const TextScaler.linear(1) ,
                      style: TextStyle(fontSize: 25, color: color),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const Instruction()));
                },
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                child: Row(
                  children: [
                    const Icon(
                      Icons.phone,
                      color:  Color.fromARGB(255, 40, 143, 134),
                      size: 25,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Helpline',
                      textScaler:const TextScaler.linear(1) ,
                      style: TextStyle(fontSize: 25, color: color),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context,
                       MaterialPageRoute(builder: (context) => const Helpline())
                      )
                       ;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              InkWell(
                child: Row(
                  children: [
                    const Icon(
                      FontAwesomeIcons.stethoscope,
                      color:  Color.fromARGB(255, 40, 143, 134),
                      size: 20,
                    ),
                    const SizedBox(width: 15),
                    Text(
                      'Smart Prediction',
                      textScaler:const TextScaler.linear(1) ,
                      style: TextStyle(fontSize: 25, color: color),
                    ),
                  ],
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute( 
                        builder: (context) => 
                      Predict(_bodytemp,stepx!)));
                }
                       
                                      
                   
                ),
              
             
            ],
          ),
        ),
      ),
    );
  }
}