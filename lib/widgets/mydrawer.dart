import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_exit_app/flutter_exit_app.dart';
import 'package:test_widgets/pages/myform.dart';
import 'package:test_widgets/pages/myhomepage.dart';
import 'package:test_widgets/pages/mydatatablepage.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/pages/mylistpage.dart';

class MyDrawer extends StatefulWidget{
  final double fontSize;
  final double width;
  const MyDrawer({super.key, required this.fontSize, required this.width});

  @override
  State<MyDrawer> createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer>{
  String _platformVersion = 'UNKNOWN';

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    try{
      platformVersion = await FlutterExitApp.platformVersion ?? 'Unknown Platform Version';
    }
    on PlatformException {
      platformVersion = 'Failed to get platform version';
    }
    if (!mounted) return;
    setState(() {
      _platformVersion = platformVersion;
    });
  }

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
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyForm()));},
          ),
          ListTile(
            leading: const Icon(Icons.data_object_sharp, color: Colors.white,),
            title: Text('ObjectBox List Page', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyListPage(future: getEmployees(),)));},
          ),
          ListTile(
            leading: const Icon(Icons.data_object_sharp, color: Colors.white,),
            title: Text('ObjectBox Table View Page', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyDataTablePage(future: getEmployees(),)));},
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app, color: Colors.white,),
            title: Text('Exit App $_platformVersion', style: TextStyle(fontSize: widget.fontSize, fontWeight: FontWeight.bold, color: Colors.white)),
            onTap: () {FlutterExitApp.exitApp(iosForceExit: true);},
          ),
        ],
      ),
    );
  }
}