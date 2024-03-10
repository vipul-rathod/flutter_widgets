import 'package:flutter/material.dart';
import 'package:test_widgets/widgets/mydrawer.dart';
import 'package:test_widgets/pages/myform.dart';

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

      bottomNavigationBar: BottomAppBar(
        height: 60,
        color: const Color.fromARGB(255, 20, 45, 90),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, size: iconSize*1.5, color: Colors.yellow[200],),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.search, size: iconSize*1.5, color: Colors.yellow[200]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.favorite_border_outlined, size: iconSize*1.5, color: Colors.yellow[200]),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.account_circle_outlined, size: iconSize*1.5, color: Colors.yellow[200]),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyForm()));},
        tooltip: 'Add Employee',
        backgroundColor: Colors.indigo[200],
        child: const Icon(Icons.add),
      ),
      body: body,
    );
  }
}