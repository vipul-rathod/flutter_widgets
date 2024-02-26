import 'package:flutter/material.dart';
import 'package:test_widgets/pages/largedeviceviewpage.dart';
import 'package:test_widgets/pages/smalldeviceviewpage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{

  @override
  Widget build(BuildContext context){
    return MyScaffold(
      title: 'Home Page',
      fontSize: 25,
      iconSize: 25,
      width: 450,
      body: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          if (constraints.maxWidth < 600){
            return const SmallDeviceViewPage();
          }
          else{
            return const LargeDeviceViewPage();
          }
        },
      ),
    );
  }
}