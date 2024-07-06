import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/components/passcode_textformfield.dart';
import 'package:food_delivery_app/components/textformfield.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:food_delivery_app/utils/extensions.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool obscurePass = true;
  bool obscurePassConfirm = true;
  bool isLoading = false;
  bool isLoadingGoogle = false;

  Map<String, dynamic> user = {};

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              TextFormFieldWidget(
                hintText: 'Username',
                labelText: 'Username',
                controller: _usernameController,
                icon: Icons.person,
                textInputType: TextInputType.text,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormFieldWidget(
                hintText: 'Email',
                labelText: 'Email',
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
              const SizedBox(
                height: 15,
              ),
              TextFormFieldWidget(
                hintText: 'Phone',
                labelText: 'Phone',
                controller: _phoneController,
                icon: Icons.phone_android,
                textInputType: TextInputType.phone,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Phone number is required';
                  }
                  return val.isValidPhone;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              PasscodeTextFormFieldWidget(
                hintText: 'Password',
                labelText: 'Password',
                controller: _passwordController,
                icon: Icons.lock_clock_outlined,
                textInputType: TextInputType.visiblePassword,
                obscurePass: obscurePass,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Password is required';
                  }
                  return val.isValidPassword;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              PasscodeTextFormFieldWidget(
                hintText: 'Confirm Password',
                labelText: 'Confirm Password',
                controller: _passwordConfirmController,
                icon: Icons.lock_clock_outlined,
                textInputType: TextInputType.visiblePassword,
                obscurePass: obscurePassConfirm,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Confirm password is required';
                  }
                  if (_passwordController.text != val) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                      ),
                    )
                  : isLoadingGoogle
                      ? const Text('')
                      : TextButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              final userRegistration = await DioProvider()
                                  .register(
                                      _usernameController.text,
                                      _emailController.text,
                                      _phoneController.text,
                                      _passwordController.text,
                                      _passwordConfirmController.text);

                              print(userRegistration);

                              if (userRegistration['data'] != null) {
                                user = json.decode(userRegistration['data']);
                                print(user);

                                MyApp.navigatorKey.currentState!.pushNamed(
                                    'reg_otp_verification',
                                    arguments: user['email']);

                                setState(() {
                                  isLoading = false;
                                });
                              } else {
                                setState(() {
                                  isLoading = false;
                                });
                                context.mounted
                                    ? showToast(
                                        userRegistration['message'],
                                        Color.fromARGB(255, 230, 225, 225),
                                        Colors.black,
                                        MediaQuery.of(context).size.width *
                                            0.035,
                                        ToastGravity.TOP)
                                    : null;
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Colors.orangeAccent),
                            overlayColor: MaterialStateProperty.all<Color>(
                                Color.fromARGB(255, 179, 174, 174)),
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          )),
              SizedBox(
                height: 20,
              ),
              isLoadingGoogle
                  ? Center(
                      child: CircularProgressIndicator(
                        color: Colors.orangeAccent,
                      ),
                    )
                  : isLoading
                      ? const Text('')
                      : SignInButton(
                          Buttons.google,
                          onPressed: _handleGoogleSignIn,
                          text: 'Sign In with Google',
                        )
            ],
          ),
        ));
  }

  void _handleGoogleSignIn() async {
    try {
      setState(() {
        isLoadingGoogle = true;
      });

      var auth = Provider.of<AuthModel>(context, listen: false);

      GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (userCredential.user != null) {
        print(userCredential.user?.displayName);

        var response = await DioProvider().signUpnWithGoogle(
            userCredential.user?.email,
            userCredential.user?.displayName ?? 'no_user_name');

        print(response);

        if (response) {
          print('inside');
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';
          final userDetail = await DioProvider().getUser(token);
          print(token);
          print(userDetail);
          if (userDetail != null) {
            setState(() {
              final userData = json.decode(userDetail);

              print(userData);

              auth.loginSuccess(userData);

              if (context.mounted) {
                showDelighfulToast(
                    context,
                    "Hello ${userData['name'] ?? 'there'}, you are Logged In!",
                    Theme.of(context).textTheme.headlineMedium?.color,
                    Icons.person,
                    Theme.of(context).canvasColor,
                    Theme.of(context).canvasColor);
              }
              isLoading = false;
            });
            MyApp.navigatorKey.currentState!.pushNamed('main_layout');
          }
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
