import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';

class Helpline extends StatefulWidget {
  const Helpline({Key? key}) : super(key: key);

  @override
  State<Helpline> createState() => _HelplineState();
}
class _HelplineState extends State<Helpline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Helpline'),
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
                leading: Text(
                  'Contact',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 193, 178)),
                ),
                title: Text(
                  'Organisation Name',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 43, 193, 178)),
                ),
                trailing: Text(
                  'Website',
                  style: TextStyle(
                      fontStyle: FontStyle.italic, fontWeight: FontWeight.bold,color: Color.fromARGB(255, 43, 193, 178)),
                ),
              ),
              HelplineTile('080-46110007', 'PAKISTAN MENTAL HEALTH COALITION (PMHC)',
                  'https://pakmh.com/#:~:text=The%20Pakistan%20Mental%20Health%20Coalition%20(PMHC)%20is%20a%20network%20of,stress%20and%20mental%20health%20problems.'),
              HelplineTile('02135397060', 'BasicNeeds Pakistan', 'https://www.mhinnovation.net/organisations/basicneeds-pakistan'),
              HelplineTile('+ (92) 0311 7786264', 'Umang Pakistan - 24 Hrs Free Mental Health Helpline', 'https://ngobase.org/profile/375'),
              HelplineTile('1800-1208-20050', 'Pakistan Association For Mental Health',
                  'https://ngobase.org/profile/194'),
              HelplineTile(
                  '044-24640050', 'Punjab Institute Of Mental Health Lahore', 'https://ngobase.org/profile/15021'),
              HelplineTile('+92-21-35832041', 'Karwan-e-Hayat',
                  'https://i-care-foundation.org/charity/karwan-e-hayat/'),
              HelplineTile('+ (92) 42-37110798-9', 'Fountain House',
                  'https://www.fountainhouse.com.pk/'),
              HelplineTile('+92 5127219002', 'ROZAN',
                  'https://rozan.org/'),
              HelplineTile('021-36100774', 'Sehat Kahani',
                  'https://sehatkahani.com/'),
              HelplineTile('(021) 34546364', 'The Recovery House, Caravan Of Life Trust', 'https://therecoveryhouse.org/'),
              HelplineTile('+9251287412021', 'Nai Zindagi Trust',
                  'https://www.naizindagi.org/'),
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

  _callNumber(String phoneNumber) async {
    String number = phoneNumber;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: IconButton(
            icon: const Icon(Icons.phone, color:  Color.fromARGB(255, 43, 193, 178),),
            onPressed: () {
              _callNumber(contact);
            },
          ),
          title: Text(
            foundation,
            style: const TextStyle(color: Color.fromARGB(255, 40, 143, 134),),
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