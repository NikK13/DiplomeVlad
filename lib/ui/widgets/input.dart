import 'package:vlad_diplome/data/utils/styles.dart';
import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  final String? hint;
  final Function? onTap;
  final bool isEnabled;
  final bool isPassword;
  final double borderRadius;
  final TextInputType? inputType;
  final TextEditingController? controller;

  const InputField({
    Key? key,
    this.hint,
    this.controller,
    this.isEnabled = true,
    this.isPassword = false,
    this.borderRadius = 16,
    this.onTap,
    this.inputType = TextInputType.text
  }) : super(key: key);

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  bool _passwordIsVisible = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap != null ? () => widget.onTap!() : null,
      child: TextField(
        enabled: widget.onTap == null,
        controller: widget.controller,
        keyboardType: widget.inputType,
        cursorColor: appColor,
        textInputAction: TextInputAction.done,
        obscureText: widget.isPassword ?
        !_passwordIsVisible : false,
        enableSuggestions: !widget.isPassword,
        autocorrect: !widget.isPassword,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black
        ),
        decoration: InputDecoration(
          hintStyle: const TextStyle(
            fontSize: 16,
            color: Colors.black
          ),
          filled: true,
          fillColor: Colors.white,
          suffixIcon: widget.isPassword ? IconButton(
            icon: Icon(
              _passwordIsVisible
                ? Icons.visibility
                : Icons.visibility_off,
              color: appColor,
            ),
            onPressed: () {
              setState(() {
                _passwordIsVisible = !_passwordIsVisible;
              });
            },
          ) : null,
          border: border,
          enabledBorder: border,
          disabledBorder: border,
          focusedBorder: border,
          hintText: widget.hint ?? "",
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 16
          )
        ),
      ),
    );
  }

  final border = const OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(8)),
    borderSide: BorderSide(
      color: Colors.white,
      width: 0.5
    )
  );
}