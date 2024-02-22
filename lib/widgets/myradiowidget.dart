import 'dart:ui';

import 'package:flutter/material.dart';

enum Gender {male, female}
class MyRadioWidget extends StatefulWidget{
  final Function(String?) onChanged;
  final double fontSize;
  const MyRadioWidget({super.key, required this.onChanged, required this.fontSize});

  @override
  State<MyRadioWidget> createState() => MyRadioWidgetState();
}

class MyRadioWidgetState extends State<MyRadioWidget>{
  Gender? gender = Gender.male;

  @override
  Widget build(BuildContext context){
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: <Widget>[
          Expanded(
            child: ListTile(
              title: Text('Select gender: ', style: TextStyle(
                color: Colors.indigo,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text('Male', style: TextStyle(
                color: Colors.indigo,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold
                ),
              ),
              leading: Radio<Gender>(
                value: Gender.male,
                groupValue: gender,
                onChanged: (Gender? value){
                  widget.onChanged.call(value!.name);
                  setState((){
                    gender = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListTile(
              title: Text('Female', style: TextStyle(
                color: Colors.indigo,
                fontSize: widget.fontSize,
                fontWeight: FontWeight.bold
                ),
              ),
              leading: Radio<Gender>(
                value: Gender.female,
                groupValue: gender,
                onChanged: (Gender? value){
                  widget.onChanged.call(value!.name);
                  setState((){
                    gender = value;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}