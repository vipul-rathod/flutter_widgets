import 'package:flutter/material.dart';
import 'package:test_widgets/pages/loginpage.dart';
import 'package:test_widgets/utils/database_helper.dart';

late ObjectBox objectbox;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  objectbox = await ObjectBox.create();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context){
    return MaterialApp(
      title: 'Employee Register Form',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(),
      // home: const MyHomePage(),
    );
  }
}
