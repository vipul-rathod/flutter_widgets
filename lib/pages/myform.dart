import 'package:flutter/material.dart';
import 'package:test_widgets/pages/myformlargepage.dart';
import 'package:test_widgets/pages/myformsmallpage.dart';
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
    return MyScaffold(
      fontSize: 25,
      iconSize: 40,
      width: 450,
      title: 'Employee Registration Formmmmm',
      body: LayoutBuilder(
        builder: (context, BoxConstraints constraints) {
          if(constraints.maxWidth < 600){
            return const MyFormSmallPage();
          }
          else{
            return const MyFormLargePage();
          }
        },
      ),
    );
  }
}