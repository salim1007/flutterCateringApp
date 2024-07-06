import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/components/passcode_textformfield.dart';
import 'package:food_delivery_app/components/toast_card.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:food_delivery_app/screens/auth_page.dart';
import 'package:food_delivery_app/utils/extensions.dart';

class PasswordRenewalPage extends StatefulWidget {
  const PasswordRenewalPage({super.key});

  @override
  State<PasswordRenewalPage> createState() => _PasswordRenewalPageState();
}

class _PasswordRenewalPageState extends State<PasswordRenewalPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
  bool obscure = true;
  bool obscureConfirm = true;

  @override
  void dispose() {
    _passwordController.dispose();
    _passwordConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userEmail = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Password Update',
          style: TextStyle(fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width > 550
              ? MediaQuery.of(context).size.width * 0.12
              : MediaQuery.of(context).size.width * 0.06),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Enter New Password',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Column(
                  children: [
                    PasscodeTextFormFieldWidget(
                      hintText: 'Password',
                      labelText: 'Password',
                      controller: _passwordController,
                      icon: Icons.lock,
                      textInputType: TextInputType.visiblePassword,
                      obscurePass: obscure,
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
                      hintText: 'Confirm password',
                      labelText: 'Confirm password',
                      controller: _passwordConfirmController,
                      icon: Icons.lock,
                      textInputType: TextInputType.visiblePassword,
                      obscurePass: obscureConfirm,
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
                  ],
                ),
                Container(
                  child: TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                            Theme.of(context).primaryColor),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          var response = await DioProvider().addNewPassword(
                              _passwordController.text, userEmail);
                          if (response['status'] == 'update_success') {
                            MyApp.navigatorKey.currentState!.pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (context) => const AuthPage()),
                              (route) => false,
                            );

                            if (context.mounted) {
                              showToast(
                                  'Update success, try logging in!',
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
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
