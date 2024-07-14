import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/textformfield.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:food_delivery_app/utils/extensions.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          onPressed: () {
            Navigator.of(context).pop();
          },
          color: Colors.white,
        ),
        title: const Text(
          'Forgot Password',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white,fontFamily: 'VarelaRound',),
        ),
        centerTitle: true,
        backgroundColor: Colors.orangeAccent,
      ),
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
                  child: Image.asset('assets/padlock.png'),
                ),
                const SizedBox(
                  height: 20,
                ),
                Text(
                  'Please enter your Email Address to receive a Verification Code',
                  style: TextStyle(
                      fontSize: MediaQuery.of(context).size.width * 0.035,
                      fontFamily: 'VarelaRound',
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                Form(
                  key: _formKey,
                  child: TextFormFieldWidget(
                    hintText: 'Email',
                    labelText: 'Enter Email',
                    controller: _emailController,
                    icon: Icons.mail,
                    textInputType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Email is required';
                      }
                      return val.isValidEmail;
                    },
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                isLoading
                    ? Center(
                        child: LoadingAnimationWidget.threeArchedCircle(
                          color: Colors.white,
                          size: MediaQuery.of(context).size.width * 0.09,
                        ),
                      )
                    : TextButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() {
                              isLoading = true;
                            });
                            final response = await DioProvider()
                                .verifyEmail(_emailController.text);
                            if (response['status'] == 'email_found') {
                              MyApp.navigatorKey.currentState!
                                  .pushNamed('verify_email', arguments: {
                                'user_email': _emailController.text,
                                'user_otp': response['otp']
                              });
                              setState(() {
                                _emailController.text = '';
                                isLoading = false;
                              });
                            } else if (response['status'] ==
                                'email_not_found') {
                              setState(() {
                                isLoading = false;
                              });
                              if (context.mounted) {
                                showToast(
                                    'No account found with this email!',
                                    Theme.of(context).canvasColor,
                                    Theme.of(context)
                                        .textTheme
                                        .headlineMedium
                                        ?.color,
                                    MediaQuery.of(context).size.width * 0.035,
                                    ToastGravity.BOTTOM);
                              }
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Colors.orangeAccent),
                          overlayColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 179, 174, 174)),
                        ),
                        child: Text(
                          'Send',
                          style: TextStyle(
                            fontSize: MediaQuery.of(context).size.width * 0.035,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'VarelaRound',
                            color: Colors.white,
                          ),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
