import 'package:flutter/material.dart';

enum Gender {male, female}

class MyRadioWidget extends StatefulWidget {
  const MyRadioWidget({super.key});

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
            onChanged: (Gender? value){
              setState((){
                gender = value;
              });
            },
          ),
        ),
      ],
    );
  }
}