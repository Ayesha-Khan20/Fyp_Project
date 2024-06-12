import 'dart:io';

import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';
class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}


class Article extends StatelessWidget {
  const Article(this.author, this.description, this.url, this.imageUrl, this.title, {super.key});
  final String? author;
  final String description;
  final String url;
  final String? imageUrl;
  final String title;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var height = size.height;
    var width = size.width;
    return Container(
      padding: const EdgeInsets.all(10.00),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                const Icon(
                  Icons.article,
                  size: 50,
                  color:  Color.fromARGB(255, 40, 143, 134),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                        color:  Color.fromARGB(255, 43, 193, 178),
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                        fontStyle: FontStyle.italic),
                  ),
                ),
              ],
            ),
            SizedBox(height: height / 60),
            // Container(
            //   child: imageUrl == null
            //       ? const SizedBox()
            //       : Image(
            //           image: NetworkImage(imageUrl!),
            //         ),
            // ),
            SizedBox(height: height / 60),
            author == null
                ? const SizedBox()
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Expanded(child: Text('- by $author')),
                    ],
                  ),
            SizedBox(height: height / 30),
            Container(
                padding: const EdgeInsets.all(25.00),
                decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: Colors.black)),
                child: Text(
                  description,
                  style: const TextStyle(color: Colors.black, fontSize: 15),
                )),
            TextButton(
              onPressed: () {
                //launchUrl(url as Uri);
                 launchUrl(Uri.parse(url));
              },
              child: const Text(
                'click on this link to know more',
                style: TextStyle(
                    color:  Color.fromARGB(255, 43, 193, 178), decoration: TextDecoration.underline),
              ),
            ),
            SizedBox(
              height: height / 60,
              child: const Divider(
                color: Colors.black,
                thickness: 3.00,
              ),
            )
          ],
        ),
      ),
    );
  }
}
