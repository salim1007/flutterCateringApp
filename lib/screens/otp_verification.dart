import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerification extends StatefulWidget {
  const OtpVerification({super.key});

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context)!.settings.arguments as String;

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
              Text(
                'A One-Time-Password was sent to your Email, enter the OTP',
                style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Form(
                key: _formKey,
                child: Pinput(
                  controller: _pinController,
                  length: 5,
                  useNativeKeyboard: true,
                  pinAnimationType: PinAnimationType.slide,
                  validator: (value) {
                    return value!.isEmpty ? 'OTP is required' : null;
                  },
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Consumer<AuthModel>(builder: (context, auth, child) {
                return TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final otpVerification = await DioProvider()
                            .verifyOtp(_pinController.text, userEmail);

                        if (otpVerification['status'] == true) {
                          final SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          final tokenValue = prefs.getString('token') ?? '';

                          if (tokenValue.isNotEmpty && otpVerification != '') {
                            final userDetail =
                                await DioProvider().getUser(tokenValue);

                            if (userDetail != null) {
                              setState(() {
                                final userData = json.decode(userDetail);

                                print(userData);

                                auth.loginSuccess(userData);

                                MyApp.navigatorKey.currentState!
                                    .pushNamed('main_layout');
                              });

                              if (context.mounted) {
                                showDelighfulToast(
                                    context,
                                    "Hello ${auth.getUser['name'] ?? 'there'}, you are Logged In!",
                                    Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.color,
                                    Icons.person,
                                    Theme.of(context).canvasColor,
                                    Theme.of(context).canvasColor);
                              }
                            }
                          }
                        } else if (otpVerification['status'] == false) {
                          if (context.mounted) {
                            showToast(
                                otpVerification['feedback'],
                                Theme.of(context).canvasColor,
                                Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.color,
                                MediaQuery.of(context).size.width * 0.035,
                                ToastGravity.TOP);
                          }
                        }
                      }
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orangeAccent),
                      overlayColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 179, 174, 174)),
                    ),
                    child: Text(
                      'Verify',
                      style: TextStyle(
                        backgroundColor: Theme.of(context).primaryColor,
                        fontSize: MediaQuery.of(context).size.width * 0.035,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
