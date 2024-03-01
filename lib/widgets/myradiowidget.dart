import 'package:flutter/material.dart';

// enum Gender {male, female}

class MyRadioWidget extends StatefulWidget{
  final Function(String?) onChanged;
  final double fontSize;
  final String? groupVal;

  const MyRadioWidget({super.key, required this.onChanged, required this.fontSize, this.groupVal,});

  @override
  State<MyRadioWidget> createState() => MyRadioWidgetState();
}

class MyRadioWidgetState extends State<MyRadioWidget>{
  // Gender? gender  = Gender.male;
  // String? gender;

  // @override
  // void initState() {
  //   super.initState();
  //   gender = widget.groupVal;
  //   print (gender);
  // }

  @override
  Widget build(BuildContext context){
    if (MediaQuery.of(context).size.width < 600){
      return Container(
        padding: const EdgeInsets.all(10),
        child: SizedBox(
          height: 150,
          child: Column(
            verticalDirection: VerticalDirection.down,
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                    onChanged: (String? value){
                      widget.onChanged.call(value!);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
    else{
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
                onChanged: (String? value){
                  widget.onChanged.call(value!);
                },
              ),
            ),
          ),
        ],
      ),
    );
    }
  }
}