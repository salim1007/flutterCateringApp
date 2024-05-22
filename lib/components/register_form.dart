import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:food_delivery_app/screens/otp_verification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_button/sign_in_button.dart';

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  final _formKey = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool obscurePass = true;
  bool obscurePassConfirm = true;

  Map<String, dynamic> user = {};

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            TextFormField(
              controller: _usernameController,
              keyboardType: TextInputType.text,
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                hintText: 'Username',
                labelText: 'Username',
                alignLabelWithHint: true,
                prefixIcon: const Icon(Icons.person_2_outlined),
                prefixIconColor: Colors.orangeAccent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                hintText: 'Email',
                labelText: 'Email',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.email_outlined),
                prefixIconColor: Colors.orangeAccent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                hintText: 'Phone',
                labelText: 'Phone',
                alignLabelWithHint: true,
                prefixIcon: Icon(Icons.phone_android),
                prefixIconColor: Colors.orangeAccent,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                    color: Colors.orangeAccent,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _passwordController,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Colors.orangeAccent,
              obscureText: obscurePass,
              decoration: InputDecoration(
                  hintText: 'Password',
                  labelText: 'Password',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  prefixIconColor: Colors.orangeAccent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePass = !obscurePass;
                      });
                    },
                    icon: obscurePass
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Colors.orangeAccent,
                          ),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: _passwordConfirmController,
              keyboardType: TextInputType.visiblePassword,
              cursorColor: Colors.orangeAccent,
              obscureText: obscurePassConfirm,
              decoration: InputDecoration(
                  hintText: 'Confirm Password',
                  labelText: 'Confirm Password',
                  alignLabelWithHint: true,
                  prefixIcon: Icon(Icons.lock_outline),
                  prefixIconColor: Colors.orangeAccent,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Colors.orangeAccent,
                      width: 2.0,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscurePassConfirm = !obscurePassConfirm;
                      });
                    },
                    icon: obscurePassConfirm
                        ? const Icon(
                            Icons.visibility_off_outlined,
                            color: Colors.black38,
                          )
                        : const Icon(
                            Icons.visibility_outlined,
                            color: Colors.orangeAccent,
                          ),
                  )),
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
                onPressed: () async {
                  final userRegistration = await DioProvider().register(
                      _usernameController.text,
                      _emailController.text,
                      _phoneController.text,
                      _passwordController.text,
                      _passwordConfirmController.text);

                  if (userRegistration != '') {
                    user = json.decode(userRegistration);
                    print(user);

                    MyApp.navigatorKey.currentState!
                        .pushNamed('reg_otp_verification', arguments: user);
                  }
                },
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.orangeAccent),
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
            SignInButton(
              Buttons.google,
              onPressed: _handleGoogleSignIn,
              text: 'Sign Up with Google',
            )
          ],
        ));
  }

  void _handleGoogleSignIn() async {
    try {
      GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(googleAuthProvider);

      var auth = Provider.of<AuthModel>(context, listen: false);

      if (_user != null) {
        print(_user!.displayName);
        var tokenValue = await DioProvider().signUpnWithGoogle(
            _user!.email!);
            
        if (tokenValue != '') {
          
          final SharedPreferences prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token') ?? '';
          final userDetail = await DioProvider().getUser(token);
          if (userDetail != null) {
            setState(() {
              final userData = json.decode(userDetail);

              print(userData);

              auth.loginSuccess(userData);

              MyApp.navigatorKey.currentState!.pushNamed('main_layout');
            });
          }
        }
      }
    } catch (error) {
      print(error);
    }
  }
}
