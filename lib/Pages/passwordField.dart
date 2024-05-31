import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  final String? hintText;
  final Widget? icon;
  final Function(String)? onChanged;

  const PasswordField({Key? key, this.hintText, this.icon, this.onChanged})
      : super(key: key);

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _passwordObscured = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (data) {
        if (data!.isEmpty) {
          return 'Field is required';
        }
      },
      obscureText: _passwordObscured,
      decoration: InputDecoration(
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                _passwordObscured = !_passwordObscured;
              });
            },
            icon: widget.icon ??
                Icon(
                  _passwordObscured ? Icons.visibility : Icons.visibility_off,
                  size: 30,
                ),
          ),
          label: Text(
            widget.hintText!,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 9, 61, 151),
            ),
          )),
    );
  }
}
