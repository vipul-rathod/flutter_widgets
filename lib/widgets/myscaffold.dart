import 'package:flutter/material.dart';
import 'package:test_widgets/widgets/mydrawer.dart';

class MyScaffold extends StatelessWidget{
  final Widget body;
  final String title;
  final double fontSize;
  final double iconSize;
  final double width;
  const MyScaffold({super.key, required this.body, required this.title, required this.fontSize, required this.iconSize, required this.width});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(size: iconSize, color: Colors.white),
        toolbarHeight: 100,
        title: Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 20, 45, 90),
      ),
      drawer: MyDrawer(fontSize: fontSize, width: width,),
      bottomNavigationBar: const BottomAppBar(color: Color.fromARGB(255, 20, 45, 90)),
      body: body,
    );
  }
}