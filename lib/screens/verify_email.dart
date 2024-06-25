import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:pinput/pinput.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {
  final _formKey = GlobalKey<FormState>();

  Stream<int> countdownStream(Duration duration) {
    return Stream.periodic(
            const Duration(seconds: 1), (x) => duration.inSeconds - x - 1)
        .take(duration.inSeconds);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final userEmail = args['user_email'];
    final userOTP = args['user_otp'];
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: Colors.white,
          ),
          title: const Text(
            'Verify Your Email',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                  height: 30,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Image.asset('assets/mail.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Please enter the 5 Digit Code sent to your email',
                  style: TextStyle(
                    fontSize: MediaQuery.of(context).size.width * 0.035,
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
                              : 'incorrect OTP';
                    },
                    onCompleted: (value) {
                      if (value == userOTP.toString()) {
                        MyApp.navigatorKey.currentState!
                            .pushNamed('renew_password', arguments: userEmail);
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
                        stream: countdownStream(const Duration(minutes: 2)),
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
                          } else if (!snapshot.hasData || snapshot.data! <= 0) {
                            return TextButton(
                                style: ButtonStyle(
                                    backgroundColor: MaterialStatePropertyAll(
                                        Theme.of(context).primaryColor)),
                                onPressed: () {
                                  //handle resend....
                                },
                                child: Text(
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
                                style: TextStyle(fontWeight: FontWeight.bold));
                          }
                        }))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
