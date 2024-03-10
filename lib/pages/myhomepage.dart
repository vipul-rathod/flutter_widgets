import 'package:flutter/material.dart';
import 'package:test_widgets/pages/largescreen/largedeviceviewpage.dart';
import 'package:test_widgets/pages/smallscreen/smalldeviceviewpage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>{

  @override
  Widget build(BuildContext context){
    if (MediaQuery.of(context).size.width < 600){
      return MyScaffold(
        title: 'Home Page',
        fontSize: 15,
        iconSize: 25,
        width: 300,
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
    else{
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
}