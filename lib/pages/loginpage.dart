import 'dart:convert';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/pages/myhomepage.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController? usernameCtrl;
  TextEditingController? passwordCtrl;

  String result = '';
  String scanResult = '';

  Future<void> scanBarcode() async {
    try {
      final qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult.rawContent;
        final resultJson = jsonDecode(result);
        usernameCtrl = TextEditingController(text: resultJson["username"]);
        passwordCtrl = TextEditingController(text: resultJson["password"]);
        validateLogin();
      });
    } on PlatformException catch(ex){
      setState(() {
        result = '$ex';
      });
    } catch (ex){
      setState(() {
        result = '$ex';
      });
    }

    // var result = await BarcodeScanner.scan();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     usernameCtrl = TextEditingController(text: '');
     passwordCtrl = TextEditingController(text: '');
    // return MyScaffold(
    //   title: 'Login Page',
    //   fontSize: size.width > 600 ? 25 : 15,
    //   iconSize: size.width > 600 ? 25 : 15,
    //   width: size.width > 600 ? 450 : 300,
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(
              label: 'UserName',
              hint: 'Enter User Name',
              controller: usernameCtrl!,
              prefixIcon: Icons.people,
              iconColor: Colors.indigo,
              fontColor: Colors.indigo,
            ),
            const SizedBox(
              height: 20,
            ),
            MyTextFormField(
              label: 'Password',
              hint: 'Enter Password',
              controller: passwordCtrl!,
              prefixIcon: Icons.password_rounded,
              iconColor: Colors.indigo,
              fontColor: Colors.indigo,
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: validateLogin,
              child: Text(
                'Login',
                style: TextStyle(
                  fontSize: size.width > 600 ? 25 : 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: scanBarcode,
              child: Text(
                'Login using QRCode Scan',
                style: TextStyle(
                  fontSize: size.width > 600 ? 25 : 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<Widget?> validateLogin() async {
    if (usernameCtrl!.text == 'admin' && passwordCtrl!.text == 'welcome@123'){
      return await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyHomePage()));
    }
    else{
      return showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Invalid Credentials'),
          content: const Text('Invalid Credentials\nPlease check Username and Password'),
          actions: <Widget>[
            IconButton(
              onPressed: () {Navigator.of(context).pop();},
              icon: const Icon(Icons.close),
            ),
          ],
        )
      );
    }
  }
}