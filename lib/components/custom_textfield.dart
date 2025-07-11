import 'package:flutter/material.dart';

class CustomTextfield extends StatelessWidget {
  // const CustomTextfield({super.key});
  final String? hintText;
  TextEditingController? controller;
  final String? Function(String?)? validate;
  final  Function(String?)? onsave;
  final int? maxLines;
  final bool isPassword;
  final bool enable;
  final TextInputType? keyboardtype;
  final TextInputAction? textInputAction;
  final FocusNode? focusNode;
  final Widget? prefix;
  final Widget? suffix;
  final bool?check;
  // final bool readOnly;
  //, this.readOnly = false

  CustomTextfield({
    this.controller,
    this.check,
    this.enable=true,
    this.focusNode,
    this.hintText,
    this.isPassword=false,
    this.keyboardtype,
    this.maxLines,
    this.onsave,
    this.prefix,
    this.suffix,
    this.textInputAction,
    this.validate,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      enabled: enable==true?true:enable,
      maxLines: maxLines==null?1:maxLines,
      onSaved: onsave,
      focusNode: focusNode,
      textInputAction: textInputAction,
      keyboardType: keyboardtype==null?TextInputType.name:keyboardtype,
      controller: controller,
      validator: validate,
      obscureText: isPassword==false?false:isPassword,
      decoration: InputDecoration(
        prefixIcon: prefix,
        suffix: suffix,
        labelText: hintText??
            "hint text..",

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.blueAccent,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.deepOrange,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(
            style: BorderStyle.solid,
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }
}
