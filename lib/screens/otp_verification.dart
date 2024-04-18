import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/otp_input.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/main_layout.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userData = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'User Verification',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.orangeAccent),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 30,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(50),
                child: Image.asset('assets/otp.png'),
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'A One-Time-Password was sent to your Email, enter the OTP',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  OtpInput(
                    autoFocus: true,
                    controller: _fieldOne,
                  ),
                  OtpInput(
                    autoFocus: false,
                    controller: _fieldTwo,
                  ),
                  OtpInput(
                    autoFocus: false,
                    controller: _fieldThree,
                  ),
                  OtpInput(
                    autoFocus: false,
                    controller: _fieldFour,
                  ),
                  OtpInput(
                    autoFocus: false,
                    controller: _fieldFive,
                  ),
                  OtpInput(
                    autoFocus: false,
                    controller: _fieldSix,
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              TextButton(
                  onPressed: () async {
                    String otpString = _fieldOne.text +
                        _fieldTwo.text +
                        _fieldThree.text +
                        _fieldFour.text +
                        _fieldFive.text +
                        _fieldSix.text;

                    final otpVerification = await DioProvider()
                        .verifyOtp(otpString, userData['email']);

                    if (otpVerification) {
                      MyApp.navigatorKey.currentState!
                          .pushNamed('auth_page');
                    }
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.orangeAccent),
                    overlayColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 179, 174, 174)),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
