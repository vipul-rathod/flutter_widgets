import 'package:flutter/material.dart';

List<String> list = ['Fresher', 'Mid Level', 'Senior Level'];

class MyDropdownWidget extends StatefulWidget{
  final Function(String) onChanged;
  final double fontSize;
  final double iconSize;
  final List list;
  const MyDropdownWidget({super.key, required this.onChanged, required this.fontSize, required this.iconSize, required this.list});

  @override
  State<MyDropdownWidget> createState() => MyDropdownWidgetState();
}

class MyDropdownWidgetState extends State<MyDropdownWidget>{
  String dropdownVal = list.first;
  

  @override
  Widget build(BuildContext context){
    return InputDecorator(
      decoration: InputDecoration(
        labelText: 'Experience Level',
        labelStyle: TextStyle(fontSize: widget.fontSize, color: Colors.indigo),
        icon: Icon(Icons.work_history, size: widget.iconSize, color: Colors.indigo,),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.all(10),
      ),
      child: ButtonTheme(
        materialTapTargetSize: MaterialTapTargetSize.padded,
        child: DropdownButton<String>(
          style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.indigo),
          hint: Text('Experience Level', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.indigo)),
          isExpanded: true,
          value: dropdownVal,
          elevation: 16,
          underline: DropdownButtonHideUnderline(
            child: Container(),
          ),
          onChanged: (String? newValue) {
            setState((){
              dropdownVal = newValue!;
            });
          },
          items: list.map<DropdownMenuItem<String>>((String value){
            return DropdownMenuItem<String>(value: value, child: Text(value),);
          }).toList(),
        ),
      ),
    );
  }
}