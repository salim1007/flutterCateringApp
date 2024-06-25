import 'package:flutter/material.dart';

class TextFormFieldWidget extends StatefulWidget {
  const TextFormFieldWidget({super.key,required this.hintText,
      required this.labelText,
      required this.controller,
      required this.icon,
      required this.textInputType,
      required this.validator});

      final String hintText;
  final String labelText;
  final TextEditingController controller;
  final IconData icon;
  final TextInputType textInputType;
  final String? Function(String?) validator;

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        controller: widget.controller,
        keyboardType:widget.textInputType,
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
          
        ),
        validator: widget.validator,);
  }
}
