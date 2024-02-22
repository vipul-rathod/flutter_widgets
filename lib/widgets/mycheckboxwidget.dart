import 'package:flutter/material.dart';

class MyCheckBoxWidget extends StatefulWidget{
  final Function(bool) onChanged;
  const MyCheckBoxWidget({super.key, required this.onChanged});

  @override
  State<MyCheckBoxWidget> createState() => MyCheckBoxWidgetState();
}

class MyCheckBoxWidgetState extends State<MyCheckBoxWidget>{
  bool isChecked = false;

  @override
  Widget build(BuildContext context){
    return CheckboxListTile(
      activeColor: Colors.indigo,
      checkColor: Colors.white,
      side: const BorderSide(width: 20, color: Colors.indigo, style: BorderStyle.solid, strokeAlign: -0.7),
      materialTapTargetSize: MaterialTapTargetSize.padded,
      title: const Text('Confim the above details', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.indigo),),
      value: isChecked,
      onChanged: (bool? value){
        widget.onChanged.call(value!);
        setState((){
          isChecked = value;
        });
      },
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}