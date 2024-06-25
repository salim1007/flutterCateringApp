import 'package:flutter/material.dart';
import 'package:food_delivery_app/components/edit_form.dart';

class EditPage extends StatefulWidget {
  const EditPage({super.key});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  @override
  Widget build(BuildContext context) {
    var args = ModalRoute.of(context)!.settings.arguments as Map;
    final emailValue = args['email'];
    final phoneValue = args['phone'];
    final addressValue = args['address'];
    final usernameValue = args['username'];
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      body: Center(
        child: EditForm(email: emailValue, phone: phoneValue, address: addressValue, username: usernameValue),
      ),
    );
  }
}