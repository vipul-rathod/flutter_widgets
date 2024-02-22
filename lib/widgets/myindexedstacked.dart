import 'package:flutter/material.dart';

class MyIndexedStacked extends StatelessWidget{
  final Function()? onPressed;
  final double fontSize;
  final int index;

  const MyIndexedStacked({super.key, required this.index, required this.onPressed, required this.fontSize});

  @override
  Widget build(BuildContext context){
    return IndexedStack(
      index: index,
      children: [
        Padding(
          padding: EdgeInsets.zero,
          child: Center(
            child: TextButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 20, 45, 90)),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              fixedSize: MaterialStateProperty.all<Size>(const Size.fromHeight(50)),),
              onPressed: onPressed,
              child: Text('Application Form', style: TextStyle(fontSize: fontSize)),
            ),
          ),
        ),
      ],
    );
  }
}