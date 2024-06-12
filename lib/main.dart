
 import 'package:email_validator/email_validator.dart';
 import 'dart:io';


 import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mental_health_app/firebase_options.dart';
import 'package:mental_health_app/intro_slide.dart';
import 'package:mental_health_app/screens/home_screen.dart';
import 'package:mental_health_app/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'screens/welcome_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
      ));
     FirebaseFirestore.instance.settings=const Settings(
      persistenceEnabled: true,
     );
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        title: 'Hope',
        debugShowCheckedModeBanner: false,
       home: Intro()
      
      );
  }
}

class Access extends StatefulWidget {
  const Access({super.key});

  @override
  State<Access> createState() => _AccessState();
}

class _AccessState extends State<Access> {
  bool userAvailable = false;
  late SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
 }

  void getCurrentUser() async {
    sharedPreferences = await SharedPreferences.getInstance();

    try {
      if (sharedPreferences.getString("HOPE") != null) {
        setState(() {
          patientInfo.email = sharedPreferences.getString("HOPE")!;
          userAvailable = true;
        });
      }
    } catch (e) {
      setState(() {
        userAvailable = false;
      });
    }
  }

 @override
  Widget build(BuildContext context) {
    return userAvailable ? const Homescreen() : const Intro();
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

//final _auth = FirebaseAuth.instance;

class _LoginScreenState extends State<LoginScreen> {
  late String email;
  late String password;
  Color color = const Color.fromARGB(255, 40, 143, 134);

  late SharedPreferences sharedPreferences;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var width = screenSize.width;
    var height = screenSize.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 205, 236, 241),
    // backgroundColor: Color.fromARGB(255, 0, 0, 0),
        appBar: AppBar(
          title: const Text('Hope',style: TextStyle(color:  Colors.white),),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 43, 193, 178),
          //backgroundColor: Color.fromARGB(255, 62, 59, 59),
        ),
        body: Container(
          padding: EdgeInsets.all(width / 20),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Image(
                  image: const AssetImage('assets/images/imagee.png'),
                  height: height / 4,
                  width: 0.75 * width,
                ),
                SizedBox(height: height / 25),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: width / 14),
                      child: const Text(
                        'User Login',
                        style: TextStyle(
                          fontSize: 20.00,
                          color: Color.fromARGB(255, 43, 193, 178) ,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                // Login Text Field
                Container(
                  padding: EdgeInsets.all(width / 20),
                  child: TextField(
                    onChanged: (value) {
                      email = value;
                    },
                    keyboardType: TextInputType.emailAddress,
                    cursorColor: color,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon:  Icon(Icons.perm_identity, color: color,),
                      hintText: 'Enter your Email',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: color,)),
                      focusedBorder:  OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(width: 2, color:color,)),
                    ),
                  ),
                ),

                // Password Text Field
                Container(
                  padding: EdgeInsets.fromLTRB(
                      width / 20, 0, width / 20, width / 20),
                  child: TextField(
                    onChanged: (value) {
                      password = value;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    cursorColor: color,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey[100],
                      prefixIcon: Icon(Icons.password, color: color),
                      hintText: 'Enter your Password',
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(color: color)),
                      focusedBorder:  OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                          borderSide: BorderSide(width: 2, color: color,)),
                    ),
                  ),
                ),

                // Login Button
                Container(
                  padding: EdgeInsets.fromLTRB(
                      width / 20, height / 30, width / 20, height / 50),
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 43, 193, 178),
                        borderRadius: BorderRadius.all(
                          Radius.circular(45.0),
                        )),
                    child: MaterialButton(
                      
                        elevation: 10.00,
                        minWidth: width / 1.2,
                        height: height / 11.5,
                        child: const Text(
                          'Login',
                          style:
                              TextStyle(color: Colors.white, fontSize: 20.00),
   ),
                        onPressed: () async {
  setState(() {
    patientInfo.email = email;
  });
  if (email.isNotEmpty && password.isNotEmpty) {
    if (password.length < 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password must contain 6 letters'),
        ),
      );
    } else if (!EmailValidator.validate(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email is not valid'),
        ),
      );
    } else {
      try {
        // Attempt to sign in with email and password
        final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        // If sign-in is successful, save email to SharedPreferences
        sharedPreferences = await SharedPreferences.getInstance();
        sharedPreferences.setString("Hope", email);
        // Navigate to the WelcomeScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
            const WelcomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // Handle specific authentication exceptions
        if (e.code == 'user-not-found') {
          print('No user found for that email.');
        } else if (e.code == 'wrong-password') {
          print('Wrong password provided for that user.');
        }
        // Show relevant error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Authentication failed: ${e.message}'),
          ),
        );
      } catch (e) {
        // Catch any other exceptions
        print(e.toString());
        // Show generic error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Authentication failed. Please try again later.'),
          ),
        );
      }
    }
  } else {
    // Show error message if email or password is empty
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please fill in both email and password.'),
      ),
    );
  }
}

                    ))),   
  
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      textScaler: TextScaler.linear(1),
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignUp())
                              );
                        },
                        child: Text(
                          'Sign Up',
                          textScaler: const TextScaler.linear(1),
                          style: TextStyle(fontSize: 17, color: color),
                        ))
                  ],
                ),
                    ],
                    )
            )),
            );
          
  }
}

class patientInfo {
  static String? name;
  static int? age;
  static String? email;
  static String? phoneNo;
  static String? friendName;
  static String? specialistName;
  static String? friendContact;
  static String? specialistContact;
  static String? profile_link;
}

 class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}