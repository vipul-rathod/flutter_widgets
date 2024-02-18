import 'package:flutter/material.dart';

enum Gender {male, female}

class MyRadioWidget extends StatefulWidget {

  final Function(String)? onChanged;

  const MyRadioWidget({super.key, required this.onChanged});

  @override
  State<MyRadioWidget> createState() => MyRadioWidgetState();
}

class MyRadioWidgetState extends State<MyRadioWidget> {
  Gender? gender = Gender.male;

  @override
  Widget build(BuildContext context){
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('Male'),
          leading: Radio(
            value: Gender.male,
            groupValue: gender,
            onChanged: (Gender? value){
              widget.onChanged?.call(value.toString());
              setState((){
                gender = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('Female'),
          leading: Radio(
            value: Gender.female,
            groupValue: gender,
            onChanged: (Gender? val){
              widget.onChanged?.call(val.toString());
              setState((){
                gender = val;
              });
            },
          ),
        ),
      ],
    );
  }
}