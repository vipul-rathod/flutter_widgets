import 'dart:async';

import 'package:flutter/material.dart';
import 'package:test_widgets/widgets/myindexedstacked.dart';
import 'package:test_widgets/pages/myform.dart';

class SmallDeviceViewPage extends StatefulWidget {
  const SmallDeviceViewPage({super.key,});

  @override
  State<SmallDeviceViewPage> createState() => SmallDeviceViewPageState();
}

class SmallDeviceViewPageState extends State<SmallDeviceViewPage>{
  final int _index = 0;
  bool isButtonPressed = false;



  startTime() async {
    var duration = const Duration(milliseconds: 100);
    return Timer(duration, () {route();});
  }

  route() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MyForm()));
  }

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: MyIndexedStacked(
              isButtonPressed: isButtonPressed,
              fontSize: 25,
              index: _index,
              onPressed: () async {
                setState(() {
                  if (isButtonPressed == false){
                    isButtonPressed = true;
                    startTime();
                    // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MyForm()));
                  }
                  else if (isButtonPressed == true) {
                    isButtonPressed = false;
                  }
                });
                
                // Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MyForm()));
              },
            ),
          ),
        ],
      ),
    );
  }
}