import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _formKey = GlobalKey<FormState>();

  late StreamController<int> _controller;
  late Stream<int> _countdownStream;
  late Timer _timer;
  late String userEmail;
  late int userOTP;

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
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    userEmail = args['user_email'];
    userOTP = args['user_otp'];
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        !didPop ? _showPopUp() : null;
      },
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text(
              'Verify Your Email',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'VarelaRound',
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
                    'Please enter the 5 Digit Code sent to your email',
                    style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Form(
                    key: _formKey,
                    child: Pinput(
                      useNativeKeyboard: true,
                      length: 5,
                      pinAnimationType: PinAnimationType.slide,
                      validator: (value) {
                        return value!.isEmpty
                            ? 'OTP is required'
                            : value == userOTP.toString()
                                ? null
                                : 'Incorrect OTP';
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
                      onCompleted: (value) {
                        if (value == userOTP.toString()) {
                          MyApp.navigatorKey.currentState!.pushNamed(
                              'renew_password',
                              arguments: userEmail);
                        }
                      },
                    ),
                  ),
                  SizedBox(
                    height: 30,
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
                                  child: Center(
                                    child: LoadingAnimationWidget
                                        .threeArchedCircle(
                                      color: Colors.white,
                                      size: MediaQuery.of(context).size.width *
                                          0.09,
                                    ),
                                  ));
                            } else if (!snapshot.hasData ||
                                snapshot.data! <= 0) {
                              return TextButton(
                                  style: ButtonStyle(
                                      backgroundColor: MaterialStatePropertyAll(
                                          Theme.of(context).primaryColor)),
                                  onPressed: () async {
                                    var response = await DioProvider()
                                        .verifyEmail(userEmail);
                                    setState(() {
                                      userOTP = response['otp'];
                                    });
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

  Future<void> _showPopUp() {
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
                fontFamily: 'VarelaRound',
                fontWeight: FontWeight.bold),
          ),
          content: Text(
            textAlign: TextAlign.center,
            'Do you really want to exit?, The process will be discarded',
            style: TextStyle(
                color: Theme.of(context).textTheme.headlineMedium?.color,
                fontSize: MediaQuery.of(context).size.width * 0.035,
                fontFamily: 'VarelaRound',
                fontWeight: FontWeight.bold),
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
                          fontFamily: 'VarelaRound',
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 16),
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
                          fontFamily: 'VarelaRound',
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
        MyApp.navigatorKey.currentState!.pop();
      } else {
        null;
      }
    });
  }
}
