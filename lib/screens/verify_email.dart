import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/otp_input.dart';

class VerifyEmail extends StatefulWidget {
  const VerifyEmail({super.key});

  @override
  State<VerifyEmail> createState() => _VerifyEmailState();
}

class _VerifyEmailState extends State<VerifyEmail> {

  final TextEditingController _fieldOne = TextEditingController();
  final TextEditingController _fieldTwo = TextEditingController();
  final TextEditingController _fieldThree = TextEditingController();
  final TextEditingController _fieldFour = TextEditingController();
  final TextEditingController _fieldFive = TextEditingController();
  final TextEditingController _fieldSix = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30,),
             ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset('assets/mail.png'),
                  ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Please enter the 6 Digit Code sent to your email',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
               children: <Widget>[
               OtpInput(autoFocus: true, controller: _fieldOne,),
               OtpInput(autoFocus: false, controller: _fieldTwo,),
               OtpInput(autoFocus: false, controller: _fieldThree,),
               OtpInput(autoFocus: false, controller: _fieldFour,),
               OtpInput(autoFocus: false, controller: _fieldFive,),
               OtpInput(autoFocus: false, controller: _fieldSix,),
                ],
              ),
              SizedBox(height: 30,),
              TextButton(
                  onPressed: () {
                    print('verify button pressed!');
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