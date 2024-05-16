import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/auth_model.dart';
import 'package:food_delivery_app/providers/dio_provider.dart';
import 'package:provider/provider.dart';

class EditForm extends StatefulWidget {
  const EditForm(
      {super.key,
      required this.email,
      required this.phone,
      required this.address});

  final String email;
  final String phone;
  final String address;

  @override
  State<EditForm> createState() => _EditFormState();
}

class _EditFormState extends State<EditForm> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _phoneController = TextEditingController(text: widget.phone);
    _addressController = TextEditingController(text: widget.address);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      margin: EdgeInsets.all(15),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            Text(
              'Edit Profile',
              style: TextStyle(fontSize: 16, color: Colors.orange[700], fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                labelText: 'Email',
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
              keyboardType: TextInputType.phone,
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                labelText: 'Phone',
                prefixIcon: Icon(Icons.phone),
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
              controller: _addressController,
              keyboardType: TextInputType.streetAddress,
              cursorColor: Colors.orangeAccent,
              decoration: InputDecoration(
                labelText: 'Address',
                prefixIcon: Icon(Icons.home),
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
                    var response = await DioProvider().updateProfile(
                        auth.getAuthUserID,
                        _emailController.text,
                        _phoneController.text,
                        _addressController.text,
                        auth.getAuthUserToken);

                        print(response);

                        if(response == true){
                          var newUserData = await DioProvider().getUser(auth.getAuthUserToken);
                          auth.updateUser(json.decode(newUserData));
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
    );
  }
}
