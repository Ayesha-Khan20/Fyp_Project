import 'dart:io';
import '../main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  Color myColor =  const Color.fromARGB(255, 43, 193, 178);
  bool canEdit = false;
  TextEditingController friendName = TextEditingController();
  TextEditingController friendPhone = TextEditingController();
  TextEditingController specialistName = TextEditingController();
  TextEditingController friendContact = TextEditingController();
  TextEditingController specialistContact = TextEditingController();

  void ProfilePic() async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 90);

    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${patientInfo.name}_profile.jpg");

    await ref.putFile(File(image?.path??"null"));

    ref.getDownloadURL().then((value) async {
      setState(() {
        patientInfo.profile_link = value;
      });

      await FirebaseFirestore.instance
          .collection('Users')
          .doc('${patientInfo.email}')
          .update({'profilePic': patientInfo.profile_link});
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friendName.text = patientInfo.friendName??"null";
    specialistName.text = patientInfo.specialistName??"null";
    friendContact.text = patientInfo.friendContact??"null";
    specialistContact.text = patientInfo.specialistContact??"null";
    friendPhone.text = patientInfo.phoneNo??"null";
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
              Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    width: 0.98 * width,
                    height: height / 5.5,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/abc.gif'),
                          fit: BoxFit.cover),
                    ),
                  ),
                  Positioned(
                    top: height / 15,
                    child: CircleAvatar(
                      radius: height / 11,
                      backgroundColor: Colors.white,
                      child: GestureDetector(
                        onTap: () {
                          ProfilePic();
                        },
                        child: CircleAvatar(
                          radius: height / 12,
                          backgroundImage: patientInfo.profile_link != null
                              ? NetworkImage(patientInfo.profile_link??"null")
                              : null,
                          backgroundColor: Colors.blueGrey,
                          child: patientInfo.profile_link == null
                              ? const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 60,
                                )
                              : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height / 14.5),
              Text(
                patientInfo.name??"null",
                style: const TextStyle(fontSize: 30),
              ),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: canEdit
                      ? [
                          TextsField("Friends Name", "Enter your Friends Name",
                              friendName, true),
                          TextsField("Friend's Email",
                              "Enter your Friends Email", friendContact, true),
                          TextsField("Friend's Phone",
                              "Enter your Friends Phone", friendPhone, true),
                          TextsField(
                              "Specialist Name",
                              "Enter Name of the Specialist",
                              specialistName,
                              true),
                          TextsField(
                              "Specialist's Contact",
                              "Enter Specialists contact No.",
                              specialistContact,
                              true),
                        ]
                      : [
                          TextsField("Friends Name", '', friendName, false),
                          TextsField(
                              "Friend's Email", '', friendContact, false),
                          TextsField("Friend's Phone", "", friendPhone, false),
                          TextsField(
                              "Specialist Name", '', specialistName, false),
                          TextsField("Specialist's Contact", '',
                              specialistContact, false),
                        ]),
              Container(
               // padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: SizedBox(
                  height: height / 13.5,
                  width: width / 3,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 43, 193, 178),
                        borderRadius: BorderRadius.circular(25)),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25)),
                        ),
                        onPressed: () async {
                          setState(() {
                            canEdit = !canEdit;
                          });
                          if (friendName.text.isEmpty) {
                            showSnackBar('Please Enter your Friends name!');
                          } else if (friendContact.text.isEmpty) {
                            showSnackBar("Please Enter your Friends email");
                          } else if (friendPhone.text.isEmpty) {
                            showSnackBar("Please Enter your Friends phone No");
                          } else {
                            await FirebaseFirestore.instance
                                .collection('Users')
                                .doc(patientInfo.email)
                                .update({
                              'friend': friendName.text,
                              'friendContact': friendContact.text,
                              'friendPhone': friendPhone.text,
                              'specialist': specialistName.text,
                              'specialistContact': specialistContact.text,
                            });
                            patientInfo.friendName = friendName.text;
                            patientInfo.friendContact = friendContact.text;
                            patientInfo.phoneNo = friendPhone.text;
                            patientInfo.specialistName = specialistName.text;
                            patientInfo.specialistContact =
                                specialistContact.text;
                            print(patientInfo.specialistContact);
                          }
                        },
                        child: Text(
                          canEdit != true ? 'Edit Profile' : 'Save',
                          style: const TextStyle(fontSize: 15),
                        )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text(
          text,
        )));
  }
}

class TextsField extends StatelessWidget {
  const TextsField(this.fieldname, this.hint, this.controller, this.editingEnabled, {super.key});
  final String fieldname;
  final String hint;
  final TextEditingController controller;
  final bool editingEnabled;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var height = screenSize.height;
    var width = screenSize.width;
    return Container(
      // padding: EdgeInsets.only(
      //     right: width / 14, left: width / 14, top: height / 68),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fieldname,
            style: editingEnabled
                ? TextStyle(color: Colors.grey[900], fontSize: 15)
                : TextStyle(
                    color: Colors.grey[900],
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic),
          ),
          SizedBox(height: height / 136),
          SizedBox(
            height: height / 12.5,
            width: width / 1.12,
            child: editingEnabled
                ? TextField(
                    readOnly: !editingEnabled,
                    controller: controller,
                    onChanged: (value) {},
                    cursorColor:  const Color.fromARGB(255, 43, 193, 178),
                    decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: hint,
                        enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                width: 2,
                                color:  Color.fromARGB(255, 43, 193, 178),)),
                        focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(
                                width: 2,
                                color:  Color.fromARGB(255, 43, 193, 178),))),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(
                        vertical: height / 40, horizontal: width / 40),
                    width: width * 0.9,
                    decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey)),
                    child: Text(
                      controller.text,
                      style: const TextStyle(color: Colors.black, fontSize: 15),
                    )),
          ),
          SizedBox(height: height / 70)
        ],
      ),
    );
  }
}
