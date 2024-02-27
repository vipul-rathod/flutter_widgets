import 'package:flutter/material.dart';
import 'package:test_widgets/widgets/myindexedstacked.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/pages/myform.dart';

class SmallDeviceViewPage extends StatefulWidget{
  const SmallDeviceViewPage({super.key});

  @override
  State<SmallDeviceViewPage> createState() => SmallDeviceViewPageState();
}

class SmallDeviceViewPageState extends State<SmallDeviceViewPage>{
  final int _currentIndex = 0;

  @override
  Widget build(BuildContext context){
    return MyScaffold(
      fontSize: 20,
      iconSize: 35,
      width: 300,
      body: Container(
        color: const Color.fromARGB(255, 193, 221, 235),
        child: MyIndexedStacked(
          isButtonPressed: false,
          fontSize: 20,
          index: _currentIndex,
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MyForm()));
          },
        ),
      ),
      title: 'Employee Register',
    );
  }
}