
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class Intro extends StatefulWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  
  final controller = OnboardingData();
  final pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Column(
        children: [
          body(),
          buildDots(),
          button(),
        ],
             ),
    );
  }

  //Body
  Widget body(){
    return Expanded(
      child: Center(
        child: PageView.builder(
            onPageChanged: (value){
              setState(() {
                currentIndex = value;
              });
            },
            itemCount: controller.items.length,
            itemBuilder: (context,index){
             return Padding(
               padding: const EdgeInsets.symmetric(horizontal: 20),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   //Images
                   SizedBox(
                    height: MediaQuery.of(context).size.height *0.3,
                        width: MediaQuery.of(context).size.height *0.3,
                     child: AnotherCarousel(
                      images: [
                        Image.asset('assets/images/mental.gif'),
                          Image.asset('assets/images/robo.gif'),
                            Image.asset('assets/images/message.gif'),

                      ],
                      
                      showIndicator: false,
                      animationDuration:const Duration(microseconds: 400),
                     
                     ),
                   ),

                   const SizedBox(height: 15),
                   //Titles
                   Text(controller.items[currentIndex].title,
                     style: const TextStyle(fontSize: 25,color: primaryColor,fontWeight: FontWeight.bold),
                     textAlign: TextAlign.center,),

                   //Description
                   Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 25),
                     child: Text(controller.items[currentIndex].description,
                       style: const TextStyle(color: Colors.grey,fontSize: 16),textAlign: TextAlign.center,),
                   ),

                 ],
               ),
             );
        }),
      ),
    );
  }

  //Dots
  Widget buildDots(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(controller.items.length, (index) => AnimatedContainer(
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration:   BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: currentIndex == index? primaryColor : Colors.grey,
          ),
          height: 7,
          width: currentIndex == index? 30 : 7,
          duration: const Duration(milliseconds: 700))),
    );
  }

  //Button
  Widget button(){
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
       width: MediaQuery.of(context).size.width *.6,
      height: 37,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: primaryColor
      ),

      child: ElevatedButton(
        
        style: ElevatedButton.styleFrom(backgroundColor: primaryColor,),
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginScreen(),
            ), //MaterialPageRoute
         );
          setState(() {
            currentIndex != controller.items.length -1? currentIndex++ : null;
          });
        },
        child: Text(currentIndex == controller.items.length -1? "Get started" : "Continue",
          style: const TextStyle(color: Colors.white),),
      ),
      );
    
  }
}

class OnboardingInfo{
  final String title;
  final String description;
  final String image;

  OnboardingInfo({
    required this.title,
    required this.description,
    required this.image});
}

 const primaryColor =  Color.fromARGB(255, 43, 193, 178);


class OnboardingData{

  List<OnboardingInfo> items = [
    OnboardingInfo(
        title: 'Care Taker',
        description: 'Keeps an eye on your vital details 24 X 7',
        image: 'assets/images/care.jpg',
         ),

    OnboardingInfo(
       title: 'Accurate results',
    description:
           'Tries its best to deliver the best functionality ',
          //for accessing mental health',
      image: 'assets/images/test.jpg'),

    OnboardingInfo(
        title: 'Always on alert',
      description: 'Can send automatic emails and start calls on a tap',
      image: 'assets/images/message.gif',)

  ];
 }
