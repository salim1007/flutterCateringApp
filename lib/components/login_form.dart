import 'dart:convert';

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
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool obscurePass = true;

  bool isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
                  return null;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              Consumer<AuthModel>(builder: (context, auth, child) {
                return isLoading
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
                            var response = await DioProvider().getToken(
                                _emailController.text,
                                _passwordController.text);

                            if (response['status'] == 200) {
                              final SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              final tokenValue = prefs.getString('token') ?? '';

                              if (tokenValue.isNotEmpty && response != '') {
                                final userDetail =
                                    await DioProvider().getUser(tokenValue);

                                if (userDetail != null) {
                                  setState(() {
                                    final userData = json.decode(userDetail);


                                    auth.loginSuccess(userData);
                                  
                                  });

                                  MyApp.navigatorKey.currentState!
                                      .pushNamed('main_layout');

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
                            } else if (response['status'] == 401) {
                              setState(() {
                                isLoading = false;
                              });
                              if (context.mounted) {
                                showToast(
                                    response['data'],
                                    Colors.redAccent,
                                    Colors.white,
                                    MediaQuery.of(context).size.width * 0.035,
                                    ToastGravity.TOP);
                              }
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
                          'Sign In',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'VarelaRound',
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ));
              })
            ],
          ),
        ));
  }
}
