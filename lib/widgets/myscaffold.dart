import 'package:flutter/material.dart';
import 'package:test_widgets/pages/loginpage.dart';
import 'package:test_widgets/pages/myhomepage.dart';
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
    final size = MediaQuery.of(context).size;
    final orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: IconThemeData(size: iconSize, color: Colors.white),
        toolbarHeight: orientation.name == "landscape" ? 50 : 100,
        title: Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold, color: Colors.white),),
        backgroundColor: const Color.fromARGB(255, 20, 45, 90),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, size: iconSize,),
            onPressed: () {showPopUpMenu(context, size);},
          ),
        ],
      ),
      drawer: MyDrawer(fontSize: fontSize, width: width,),

      bottomNavigationBar: BottomAppBar(
        height: orientation.name == "landscape" ? 30 : 60,
        color: const Color.fromARGB(255, 20, 45, 90),
        shape: const CircularNotchedRectangle(),
        notchMargin: 10.0,
        clipBehavior: Clip.antiAlias,
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.home, size: iconSize*1.5, color: Colors.yellow[200],),
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));},
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
                onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));},
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
  void showPopUpMenu(context, size) {
    showMenu<String>(
      context: context,
      position: size.width > 600 ? const RelativeRect.fromLTRB(25, 130, 0, 0) : const RelativeRect.fromLTRB(25, 110, 0, 0),
      color: Colors.white,
      items: [
        PopupMenuItem<String>(
          child: const Text('LogOut'),
          onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => logOut(context)));},
          // onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ScanBarcode()));},
        ),
      ]
    );
  }
  Widget logOut(context) {
    return AlertDialog(
      title: const Text('Are you sure to logout?'),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginPage()));},
          child: const Text('LogOut'),
        ),
                ElevatedButton(
          onPressed: () {Navigator.of(context).pop();},
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}