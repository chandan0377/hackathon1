import 'package:flutter/material.dart';
import 'package:hackathon1/screen/home_screen.dart';

import 'package:lottie/lottie.dart';

import '../helper/global.dart';
import '../model/onboard.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = PageController();

    final list = [
      //onboarding 1
      Onboard(
          title: 'Reduce',
          subtitle:
              'Start Small, Reduce It All : Every Step Counts for the Planet',
          lottie: 'lottie1'),

      //onboarding 2
      Onboard(
        title: 'Reuse',
        lottie: 'lottie2',
        subtitle:
            'Old Things, New Beginnings : Creativity Meets Sustainability in Every Step',
      ),

      //onboarding 3
      Onboard(
        title: 'Recycle',
        lottie: 'lottie3',
        subtitle:
            'Recycle Smart, Do Your Part : Every Effort Counts for a Greener World',
      ),
    ];

    return Scaffold(
      body: PageView.builder(
        controller: c,
        itemCount: list.length,
        itemBuilder: (ctx, ind) {
          final isLast = ind == list.length - 1;

          return Column(
            children: [
              //lottie
              Lottie.asset('assets/lottie/${list[ind].lottie}.json',
                  height: mq.height * .6,
                  width: isLast ? mq.width * .67 : null),


              //title
              Text(
                list[ind].title,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .5),
              ),

              //for adding some space
              SizedBox(height: mq.height * .015),

              //subtitle
              SizedBox(
                width: mq.width * .7,
                child: Text(
                  list[ind].subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 13.5, letterSpacing: .5, color: Colors.black54),
                ),
              ),

              const Spacer(),

              //dots

              Wrap(
                spacing: 10,
                children: List.generate(
                    list.length,
                    (i) => Container(
                          width: i == ind ? 15 : 10,
                          height: 8,
                          decoration: BoxDecoration(
                              color: i == ind ? Colors.blue : Colors.grey,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5))),
                        )),
              ),

              const Spacer(),

              //button
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: const StadiumBorder(),
                      elevation: 0,
                      textStyle: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500),
                      minimumSize: Size(mq.width * .4, 50)),
                  onPressed: () {
                    if (isLast) {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (_) => HomeScreen()));
                    } else {
                      c.nextPage(
                          duration: Duration(milliseconds: 600),
                          curve: Curves.ease);
                    }
                  },
                  child: Text(isLast ? 'Finish' : 'Next')),

              const Spacer(flex: 2),
            ],
          );
        },
      ),
    );
  }
}
