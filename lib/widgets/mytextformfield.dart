import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextFormField extends StatefulWidget{
  const MyTextFormField({super.key, required this.label, required this.hint, required this.controller,
    required this.prefixIcon, required this.iconSize, this.onTap, this.focusNode, this.validator,
    required this.iconColor, required this.fontColor, required this.fontSize, this.inputFormatter, this.suffixIcon});

  final String label;
  final String hint;
  final TextEditingController controller;
  final IconData prefixIcon;
  final double iconSize;
  final Color iconColor;
  final Color fontColor;
  final double fontSize;
  final List<TextInputFormatter>? inputFormatter;
  final IconData? suffixIcon;
  final Function()? onTap;
  final FocusNode? focusNode;
  final String? Function(String?)? validator;
  



  @override
  State<MyTextFormField> createState() => MyTextFormFieldState();
}

class MyTextFormFieldState extends State<MyTextFormField>{

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: widget.controller,
      autocorrect: false,
      focusNode: widget.focusNode,
      inputFormatters: widget.inputFormatter,
      style: TextStyle(fontSize: widget.fontSize, color: widget.fontColor),
      decoration: InputDecoration(
        icon: Icon(widget.prefixIcon, size: widget.iconSize, color: widget.iconColor,),
        suffixIcon: Icon(widget.suffixIcon, size: widget.iconSize, color: widget.iconColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: widget.iconColor),
          borderRadius: BorderRadius.circular(25.0),
        ),
        label: Text(widget.label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize, color: widget.iconColor),),
        hintText: widget.hint,
        errorStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: widget.fontSize/1.1, color: Colors.red),
      ),
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onTap: widget.onTap,
    );
  }
}