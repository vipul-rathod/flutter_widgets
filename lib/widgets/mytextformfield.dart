import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatefulWidget{
  const MyTextFormField({super.key, required this.label, required this.hint, required this.controller,
    required this.prefixIcon, this.onTap, this.focusNode, this.validator,
    required this.iconColor, required this.fontColor, this.inputFormatter, this.keyboardType,this.suffixIcon, this.obscureText=false});

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData prefixIcon;
  final Color iconColor;
  final Color fontColor;
  final List<TextInputFormatter>? inputFormatter;
  final dynamic keyboardType;
  final IconData? suffixIcon;
  final Function()? onTap;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  final bool obscureText;



  @override
  State<MyTextFormField> createState() => MyTextFormFieldState();
}

class MyTextFormFieldState extends State<MyTextFormField>{

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return TextFormField(
      controller: widget.controller,
      autocorrect: false,
      maxLength: 25,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatter,
      keyboardType: widget.keyboardType,
      style: TextStyle(
        fontSize: size.width > 600 ? 25 : 15,
        color: widget.fontColor,
      ),
      decoration: InputDecoration(
        icon: Icon(
          widget.prefixIcon,
          size: size.width > 600 ? 25 : 15,
          color: widget.iconColor,
        ),
        suffixIcon: Icon(
          widget.suffixIcon,
          size: size.width > 600 ? 25 : 15,
          color: widget.iconColor,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.iconColor),
          borderRadius: BorderRadius.circular(25.0),
        ),
        label: Text(widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: size.width > 600 ? 25 : 15,
            color: widget.iconColor,
          ),
        ),
        hintText: widget.hint,
        errorStyle: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: size.width > 600 ? 25 : 15, color: Colors.red),
      ),
      validator: widget.validator,
      obscureText: widget.obscureText,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: widget.onTap,
    );
  }
}