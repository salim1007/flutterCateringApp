import 'package:flutter/material.dart';

class OtpInput extends StatelessWidget {
  const OtpInput({super.key, required this.controller, required this.autoFocus});

  final TextEditingController controller;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
     return SizedBox(
      height: 60,
      width: 50,
      child: TextField(
        autofocus: autoFocus,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        controller: controller,
        maxLength: 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          counterText: '',
          hintStyle: TextStyle(color: Colors.black, fontSize: 20.0,fontFamily: 'VarelaRound',)
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }else if(value.isEmpty){
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }
}