import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

class Maps extends StatefulWidget {
  const Maps({Key? key}) : super(key: key);

  @override
  State<Maps> createState() => _MapsState();
}
class _MapsState extends State<Maps> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maps'),
        centerTitle: true,
        backgroundColor:  const Color.fromARGB(255, 43, 193, 178),
      ),
      body: Container(
        padding: const EdgeInsets.all(15),
        child: const SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ListTile(
                leading: Icon(Icons.map,size: 20,color:Colors.black,),
                title: Text(
                  'Organisation Name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                trailing: Text(
                  'Maps',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold,color: Colors.black),
                ),
              ),
              HelplineTile('', 'PAKISTAN MENTAL HEALTH COALITION (PMHC)',
                  'https://maps.app.goo.gl/qmcXay6p2cmii96v6'),
              HelplineTile('', 'BasicNeeds Pakistan', 'https://maps.app.goo.gl/fK5kKrLZq5SaKnwb9'),
              HelplineTile('', 'Umang Pakistan - 24 Hrs Free Mental Health Helpline', 'https://maps.app.goo.gl/ugCPhQX54L2oikjHA'),
              HelplineTile('', 'Pakistan Association For Mental Health',
                  'https://maps.app.goo.gl/Z6fFySY3uaa6HMXo8'),
              HelplineTile(
                  '', 'Punjab Institute Of Mental Health Lahore', 'https://maps.app.goo.gl/ysQV6o7GNwGn3xuKA'),
              HelplineTile('', 'Karwan-e-Hayat',
                  'https://maps.app.goo.gl/S4uVuWLTQUEWxyr49'),
              HelplineTile('', 'Fountain House Lahore',
                  'https://maps.app.goo.gl/JZQYoxsqQsPP5YaLA'),
              HelplineTile('', 'ROZAN',
                  'https://maps.app.goo.gl/TwmrjzEVHaariSQt5'),
              HelplineTile('', 'Sehat Kahani',
                  'https://maps.app.goo.gl/D5K6JaR7xBLp3Kar6'),
              HelplineTile('', 'The Recovery House, Caravan Of Life Trust', 'https://maps.app.goo.gl/dwj1tXTSekR7VMt79'),
              HelplineTile('', 'Nai Zindagi Trust',
                  'https://maps.app.goo.gl/BtoZEeEvfg6ZBdi36'),
            ],
          ),
        ),
      ),
    );
  }
}
class HelplineTile extends StatelessWidget {
  const HelplineTile(this.contact, this.foundation, this.websiteUrl, {super.key});
  final String contact;
  final String foundation;
  final String websiteUrl;
  
  


  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.map,size: 20,color: Colors.black,),
          title: Text(
            foundation,
            style: const TextStyle(color: Colors.black ,),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.open_in_new_rounded, color:Color.fromARGB(255, 43, 193, 178)),
            onPressed: () {
           //   launch(websiteUrl);
          launchUrl(Uri.parse(websiteUrl));
            },
          ),
          tileColor: Colors.grey[200],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}