import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:lottie/lottie.dart';
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

  late StreamController<int> _controller;
  late Stream<int> _countdownStream;
  late Timer _timer;
  late String userEmail;

  @override
  void initState() {
    super.initState();
    _controller = StreamController<int>();
    _countdownStream = _controller.stream;

    _startCountdown();
  }

  void _startCountdown() {
    const Duration duration = Duration(minutes: 2);
    int remainingSeconds = duration.inSeconds;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      remainingSeconds--;
      _controller.add(remainingSeconds);

      if (remainingSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _controller.close();
    _timer.cancel();
    super.dispose();
  }

  void _handleResend() {
    _controller = StreamController<int>();
    _countdownStream = _controller.stream;
    _startCountdown();
  }

  @override
  Widget build(BuildContext context) {
    userEmail = ModalRoute.of(context)!.settings.arguments as String;

    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        !didPop ? _showPopUp(userEmail) : null;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'User Verification',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: Colors.orangeAccent),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.width * 0.5,
                    child: ClipRRect(
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).canvasColor,
                        radius: MediaQuery.of(context).size.width * 0.25,
                        child: Lottie.asset(
                          'assets/otp.json',
                        ),
                      ),
                    ),
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
                      errorBuilder: (errorText, value) {
                        return Padding(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          child: Center(
                            child: Text(
                              errorText ?? '',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
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

                              if (tokenValue.isNotEmpty &&
                                  otpVerification != '') {
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
                            backgroundColor: MaterialStatePropertyAll(
                                Theme.of(context).primaryColor)),
                        child: const Text(
                          'Verify',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ));
                  }),
                  SizedBox(
                    height: 20,
                  ),
                  Column(
                    children: [
                      Text(
                        "Didn't recieve code?",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      StreamBuilder(
                          stream: _countdownStream,
                          builder: ((context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                  strokeWidth: 3,
                                ),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data! <= 0) {
                              return TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Theme.of(context).primaryColor)),
                                  onPressed: () async {
                                    await DioProvider().verifyEmail(userEmail);

                                    context.mounted
                                        ? showToast(
                                            'OTP sent!',
                                            Theme.of(context).canvasColor,
                                            Theme.of(context)
                                                .textTheme
                                                .headlineMedium
                                                ?.color,
                                            MediaQuery.of(context).size.width *
                                                0.035,
                                            ToastGravity.BOTTOM)
                                        : null;
                                    _handleResend();
                                  },
                                  child: const Text(
                                    'Resend',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ));
                            } else {
                              int minutes = (snapshot.data! / 60).floor();
                              int seconds = snapshot.data! % 60;
                              return Text(
                                  "Resend code in: $minutes:${seconds.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold));
                            }
                          }))
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showPopUp(String email) {
    return showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
            backgroundColor: Theme.of(context).canvasColor,
          title: Text(
            textAlign: TextAlign.center,
            'Confirm Exit',
            style: TextStyle(
               color: Theme.of(context).textTheme.headlineMedium?.color,
                fontSize: MediaQuery.of(context).size.width * 0.04,
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            textAlign: TextAlign.center,
            'Do you really want to exit?, The process will be discarded',
            style: TextStyle(
              color: Theme.of(context).textTheme.headlineMedium?.color,
              fontSize: MediaQuery.of(context).size.width * 0.035,
              fontWeight: FontWeight.bold
            ),
          ),
          actions: [
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.orangeAccent)),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 16), // Add some spacing between the buttons
                  TextButton(
                    style: const ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.orangeAccent)),
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: MediaQuery.of(context).size.width * 0.033,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    ).then((value) async {
      if (value == true) {
        var response = await DioProvider().removeUser(email);
        response ? MyApp.navigatorKey.currentState!.pop() : null;
      } else {
        null;
      }
    });
  }
}
