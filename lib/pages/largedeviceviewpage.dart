import 'package:flutter/material.dart';
import 'package:test_widgets/widgets/mydrawer.dart';
import 'package:test_widgets/widgets/myindexedstacked.dart';
import 'package:test_widgets/pages/myform.dart';

class LargeDeviceViewPage extends StatefulWidget {
  const LargeDeviceViewPage({super.key});

  @override
  State<LargeDeviceViewPage> createState() => LargeDeviceViewPageState();
}

class LargeDeviceViewPageState extends State<LargeDeviceViewPage>{
final int _index = 0;

  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.zero,
      child: Row(
        children: [
          const Expanded(
            flex: 2,
            child: MyDrawer(fontSize: 25, width: 450,),
          ),
          Expanded(
            flex: 3,
            child: MyIndexedStacked(
              fontSize: 25,
              index: _index,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=> const MyForm()));
              },
            ),
          ),
        ],
      ),
    );
  }
}