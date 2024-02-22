import 'package:flutter/material.dart';
import 'package:test_widgets/pages/myhomepage.dart';

class MyDrawer extends StatefulWidget{
  final double fontSize;
  final double width;
  const MyDrawer({super.key, required this.fontSize, required this.width});

  @override
  State<MyDrawer> createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer>{

  @override
  Widget build(BuildContext context){
    return Drawer(
      width: widget.width,
      backgroundColor: const Color.fromARGB(255, 20, 45, 90),
      child: ListView(
        children: <Widget>[
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(color: Colors.black38),
            accountName: Text('Vipul Rathod', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold)),
            accountEmail: Text('rathodvipul2204@gmail.com', style: TextStyle(fontSize: widget.fontSize, fontWeight:  FontWeight.bold),),
            currentAccountPicture: const FlutterLogo(),
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.white,),
            title: Text('Home Page', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));},
          ),
          ListTile(
            leading: const Icon(Icons.dynamic_form, color: Colors.white,),
            title: Text('Application Page', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.data_object_sharp, color: Colors.white,),
            title: Text('Hive App Page', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white,),
            title: Text('Exit App', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}