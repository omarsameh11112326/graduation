import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField(
      {this.hintText, this.icon, this.color, this.controller, this.onchanged,this.onfieldsubmitted});

  String? hintText;
  Function(String)? onchanged;
    Function(String)? onfieldsubmitted;

  Widget? icon;
  Color? color;
  TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'Field is required';
        }
      },
      onChanged: onchanged,
      onFieldSubmitted:onfieldsubmitted ,
      decoration: InputDecoration(
          suffixIcon: icon,
          label: Text(
            hintText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          )),
    );
  }
}
