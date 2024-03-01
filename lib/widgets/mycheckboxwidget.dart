import 'package:flutter/material.dart';

class MyCheckBoxWidget extends StatefulWidget{
  final Function(bool?) onChanged;
  final bool? val;
  final double fontSize;


  const MyCheckBoxWidget({super.key, required this.onChanged, required this.val, required this.fontSize});

  @override
  State<MyCheckBoxWidget> createState() => MyCheckBoxWidgetState();
}

class MyCheckBoxWidgetState extends State<MyCheckBoxWidget>{
  bool? isChecked;

  @override
  Widget build(BuildContext context){
    if (widget.val == null){
      isChecked = false;
    }
    else{
      isChecked = widget.val;
    }
    
    return CheckboxListTile(
      activeColor: Colors.indigo,
      checkColor: Colors.white,
      side: const BorderSide(width: 20, color: Colors.indigo, style: BorderStyle.solid, strokeAlign: -0.7),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      title: Text('Confim the above details', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.indigo),),
      value: isChecked,
      onChanged: (bool? value){
        widget.onChanged.call(value);
        setState((){
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}