import 'package:flutter/material.dart';

class PasscodeTextFormFieldWidget extends StatefulWidget {
  const PasscodeTextFormFieldWidget({
    super.key,
    required this.hintText,
    required this.labelText,
    required this.controller,
    required this.icon,
    required this.textInputType,
    required this.obscurePass,
    required this.validator,
  });

  final String hintText;
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType textInputType;
  final bool obscurePass;
  final String? Function(String?) validator;

  @override
  State<PasscodeTextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<PasscodeTextFormFieldWidget> {
  late bool _obscurePass;

  @override
  void initState() {
    super.initState();
    _obscurePass = widget.obscurePass;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      obscureText: _obscurePass,
      cursorColor: Colors.orangeAccent,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: Theme.of(context).hintColor),
        labelText: widget.labelText,
        labelStyle: TextStyle(color: Theme.of(context).hintColor),
        alignLabelWithHint: true,
        prefixIcon: Icon(widget.icon),
        prefixIconColor: Theme.of(context).hintColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 222, 146, 46),
            width: 2.0,
          ),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscurePass = !_obscurePass;
            });
          },
          icon: _obscurePass
              ? Icon(
                  Icons.visibility_off_outlined,
                  color: Theme.of(context).hintColor,
                )
              : Icon(
                  Icons.visibility_outlined,
                  color: Theme.of(context).hintColor,
                ),
        ),
      ),
      validator: widget.validator,
    );
  }
}
