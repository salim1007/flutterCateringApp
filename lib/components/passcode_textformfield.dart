import 'package:flutter/material.dart';

class PasscodeTextFormFieldWidget extends StatefulWidget {
   PasscodeTextFormFieldWidget(
      {super.key,
      required this.hintText,
      required this.labelText,
      required this.controller,
      required this.icon,
      required this.textInputType,
      required this.obscurePass,
      required this.validator});

  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType textInputType;
  bool? obscurePass;
  final String? Function(String?) validator;
 

  @override
  State<PasscodeTextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<PasscodeTextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: widget.obscurePass!,
      cursorColor: Colors.orangeAccent,
      decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.labelText,
          labelStyle: TextStyle(color: Theme.of(context).highlightColor),
          alignLabelWithHint: true,
          prefixIcon: Icon(widget.icon),
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
                widget.obscurePass = !widget.obscurePass!;
              });
            },

            icon: widget.obscurePass!
                ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Colors.black38,
                  )
                : const Icon(
                    Icons.visibility_outlined,
                    color: Colors.orangeAccent,
                  ),
          )),
          validator: widget.validator,
    );
  }
}
