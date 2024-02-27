import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:test_widgets/pages/mydatatablepage.dart';
import 'package:test_widgets/pages/myform.dart';
import 'package:test_widgets/pages/myhomepage.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/main.dart';

class MyZoomDrawer extends StatefulWidget {
  const MyZoomDrawer({super.key});

  @override
  State<MyZoomDrawer> createState() => MyZoomDrawerState();
}

class MyZoomDrawerState extends State<MyZoomDrawer> {
  MenuItem currentItem = MenuItems.home;

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  @override
  Widget build(BuildContext context) => ZoomDrawer(
    style: DrawerStyle.style2,
    mainScreen: getScreen()!,
    menuScreen: Builder(
      builder: (context) => MenuPage(
      currentItem: currentItem,
      onSelectedItem: (item) {
        setState(() => currentItem = item);
        ZoomDrawer.of(context)!.close();
      }
    ),
    
  )
  );
  Widget? getScreen() {
    switch (currentItem){
      case MenuItems.home:
        return const MyHomePage();
      case MenuItems.appForm:
        return const MyForm();
      case MenuItems.viewList:
        return MyDataTablePage(future: getEmployees(),);
    }
  }
}

class MenuItem {
  final String title;
  final IconData icon;
  const MenuItem(this.title, this.icon);
}

class MenuItems {
  static const home = MenuItem('Home', Icons.home);
  static const appForm = MenuItem('Application Form', Icons.pages);
  static const viewList = MenuItem('View List', Icons.list);
  static const exit = MenuItem('Exit', Icons.exit_to_app);

  static const all = <MenuItem>[
    home,
    appForm,
    viewList,
    exit,
  ];
}



class MenuPage extends StatelessWidget {
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage({super.key, required this.currentItem, required this.onSelectedItem});

  @override
  Widget build(BuildContext context) => Theme(data: ThemeData.dark(), 
    child: Scaffold(
      backgroundColor: Colors.indigo,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Spacer(),
            ...MenuItems.all.map(buildMenuItem).toList(),
            const Spacer(flex: 2,),
          ],
        )
      ),
    )
  );

  Widget buildMenuItem(MenuItem item) => ListTileTheme(
    selectedColor: Colors.white,
    child: ListTile(
    selectedTileColor: Colors.black26,
    selected: currentItem == item,
    minLeadingWidth: 20,
    leading: Icon(item.icon),
    title: Text(item.title),
    onTap: () => onSelectedItem(item),
  ),
  );
}

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => 
  Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.blue,
      title: const Text('Home Page'),
      leading: const MenuWidget(),
    ),
  );
}

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) => IconButton(
    icon: const Icon(Icons.menu),
    onPressed: () => ZoomDrawer.of(context)!.toggle()
  );
}