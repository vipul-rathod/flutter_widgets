import 'package:flutter/material.dart';
import 'package:test_widgets/pages/myformpage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';

class MyForm extends StatefulWidget{
  const MyForm({super.key});

  @override
  State<MyForm> createState() => MyFormState();
}

class MyFormState extends State<MyForm>{
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    if (MediaQuery.of(context).size.width < 600){
      return MyScaffold(
        fontSize: 15,
        iconSize: 25,
        width: 300,
        title: 'Employee Registration Form New',
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) => const MyFormPage()
        ),
      );
    }
    else{
      return MyScaffold(
        fontSize: 25,
        iconSize: 40,
        width: 450,
        title: 'Employee Registration Form New',
        body: LayoutBuilder(
          builder: (context, BoxConstraints constraints) => const MyFormPage(),
        ),
      );
    }
  }
}