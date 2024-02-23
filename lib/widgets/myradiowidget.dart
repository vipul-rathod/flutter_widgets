import 'package:flutter/material.dart';

// enum Gender {male, female}

class MyRadioWidget extends StatefulWidget{
  final Function(String?) onChanged;
  final double fontSize;
  String? groupVal;

  MyRadioWidget({super.key, required this.onChanged, required this.fontSize, this.groupVal});

  @override
  State<MyRadioWidget> createState() => MyRadioWidgetState();
}

class MyRadioWidgetState extends State<MyRadioWidget>{
  // Gender? gender  = Gender.male;
  // String? gender;

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
              leading: Radio<String?>(
                value: 'male',
                groupValue: widget.groupVal,
                onChanged: (String? value){
                  widget.onChanged.call(value!);
                  setState((){
                    widget.groupVal = value.toString();
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
              leading: Radio<String?>(
                value: 'female',
                groupValue: widget.groupVal,
                // onChanged: (val) {},
                onChanged: (String? value){
                  widget.onChanged.call(value!);
                  // setState((){
                  //   widget.groupVal = value.toString();
                  // });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}