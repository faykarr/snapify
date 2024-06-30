import 'package:flutter/material.dart';
import 'package:snapify/utils/constant.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        color: backgroundColor1,
        height: screenSize.height,
        width: screenSize.width,
        child: Stack(
          children: [
            //   Top Section
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: screenSize.height * 0.5,
                width: screenSize.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(48),
                      bottomRight: Radius.circular(48),
                    ),
                    color: backgroundColor2),
              ),
            ),

            //   Middle Section (Image Section)
            Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 110,
                  ),
                  Image.asset('assets/images/splash-logo.png'),
                  const Text(
                    'Snapify',
                    style: TextStyle(
                      fontWeight: FontWeight.w900,
                      fontSize: 48.0,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                      right: 40,
                      left: 40,
                    ),
                    child: Text(
                      'Effortlessly save images and videos from the internet. Preview and download with ease. Your content, your gallery.',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 75),
                    child: Container(
                      height: screenSize.height * 0.065,
                      width: screenSize.width,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: buttonColor,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12.withOpacity(0.05),
                            spreadRadius: 1,
                            blurRadius: 7,
                            offset: const Offset(0, -1),
                          ),
                        ],
                      ),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          // No shadow directly from the button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          padding: EdgeInsets
                              .zero, // Remove padding so the container's padding is used
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            child: const Text(
                              'Getting Started',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
