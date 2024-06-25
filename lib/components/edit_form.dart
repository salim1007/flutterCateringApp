import 'dart:convert';

import 'package:delightful_toast/delight_toast.dart';
import 'package:delightful_toast/toast/components/toast_card.dart';
import 'package:delightful_toast/toast/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/delightful_toast.dart';
import 'package:food_delivery_app/components/textformfield.dart';
import 'package:food_delivery_app/main.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:food_delivery_app/utils/extensions.dart';
import 'package:provider/provider.dart';

class EditForm extends StatefulWidget {
  const EditForm(
      {super.key,
      required this.email,
      required this.phone,
      required this.address,
      required this.username});

  final String email;
  final String phone;
  final String address;
  final String username;

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
    _usernameController = TextEditingController(text: widget.username);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width > 550
          ? MediaQuery.of(context).size.width * 0.24
          : MediaQuery.of(context).size.width * 0.01),
      margin: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: [
              Text(
                'Edit Profile',
                style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).highlightColor,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 20,
              ),
              TextFormFieldWidget(
                hintText: 'Username',
                labelText: 'Username',
                controller: _usernameController,
                icon: Icons.person,
                textInputType: TextInputType.name,
                validator: (val) {
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
                  return val!.isValidEmail;
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
                  return val!.isValidPhone;
                },
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormFieldWidget(
                hintText: 'Address',
                labelText: 'Address',
                controller: _addressController,
                icon: Icons.home,
                textInputType: TextInputType.streetAddress,
                validator: (val) {
                  return null;
                },
              ),
              SizedBox(
                height: 10,
              ),
              Consumer<AuthModel>(builder: (context, auth, child) {
                return TextButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.orangeAccent),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        var response = await DioProvider().updateProfile(
                            auth.getAuthUserID,
                            _usernameController.text,
                            _emailController.text,
                            _phoneController.text,
                            _addressController.text,
                            auth.getAuthUserToken);

                        print(auth.getAuthUserID);

                        if (response != '') {
                          var newUserData = await DioProvider()
                              .getUser(auth.getAuthUserToken);
                          auth.updateUser(json.decode(newUserData));

                          if (context.mounted) {
                            showDelighfulToast(
                                context,
                                "Profile updated successfully!",
                                Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.color,
                                Icons.person,
                                Theme.of(context).canvasColor,
                                Theme.of(context).canvasColor);
                          }

                          MyApp.navigatorKey.currentState!.pop();
                        }
                      }
                    },
                    child: const Text(
                      'Update',
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ));
              })
            ],
          ),
        ),
      ),
    );
  }
}
