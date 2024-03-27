import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/pages/myeditformpage.dart';
import 'package:test_widgets/widgets/mycheckboxwidget.dart';
import 'package:test_widgets/widgets/mycreateprofileimage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/pages/pdfapi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';

class MyViewFormPage extends StatefulWidget {
  final int? id;
  const MyViewFormPage({super.key, required this.id});

  @override
  State<MyViewFormPage> createState() => MyViewFormPageState();
}

class MyViewFormPageState extends State<MyViewFormPage> {
  final formKey = GlobalKey<FormState>();
  String dropdownValue = '';
  String genderValue = '';
  Employee? data;
  TextEditingController? nameCtrl;
  TextEditingController? dobCtrl;
  TextEditingController? phoneCtrl;
  TextEditingController? emailCtrl;
  TextEditingController? descController;
  List<String> list1 = [];

  static File? pdfFilePath;

  @override
  void initState() {
    super.initState();
    data = objectbox.employeeBox.get(widget.id!);
    nameCtrl = TextEditingController(text: data!.name.toString());
    dobCtrl = TextEditingController(text: data!.dob.toString());
    phoneCtrl = TextEditingController(text: data!.phone.toString());
    emailCtrl = TextEditingController(text: data!.email.toString());

    if (data?.expLevel != null) {
      list1 = [data!.expLevel!];
    } else {
      list1 = ['Fresher'];
      debugPrint("expLevel is null");
    }
  }


String text = '';
convert(TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;

    if (newText.length == 10) {
      // The below code gives a range error if not 10.
      RegExp phone = RegExp(r'(\d{3})(\d{3})(\d{4})');
      var matches = phone.allMatches(newValue.text);
      var match = matches.elementAt(0);
      newText = '(${match.group(1)}) ${match.group(2)}-${match.group(3)}';
    }

    setState(() {
      text = newText;
    });

    return TextEditingValue(
        text: newText,
        selection: TextSelection(
            baseOffset: newValue.text.length,
            extentOffset: newValue.text.length));
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    setState(() {
      dropdownValue = data!.expLevel.toString();
      genderValue = data!.gender.toString();
    });
    return MyScaffold(
      fontSize: size.width > 600 ? 25 : 15,
      iconSize: size.width > 600 ? 25 : 15,
      width: size.width > 600 ? 450 : 300,
      title: 'View Form',
      body: Container(
        alignment: Alignment.topCenter,
        decoration:
            const BoxDecoration(color: Color.fromARGB(255, 225, 245, 245)),
        padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                MyProfileImage(
                  imagelocalpath: data!.profileImagePath,
                  viewmode: false,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyTextFormField(
                    label: 'Employee Name',
                    hint: 'Please enter name of employee',
                    controller: nameCtrl!,
                    prefixIcon: Icons.people,
                    iconColor: Colors.indigo,
                    fontColor: Colors.black,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))
                    ],
                    focusNode: AlwaysDisabledFocusNode(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: MyTextFormField(
                    label: 'Date Of Birth',
                    hint: 'Enter the date of birth',
                    controller: dobCtrl!,
                    prefixIcon: Icons.calendar_today,
                    iconColor: Colors.indigo,
                    fontColor: Colors.black,
                    onTap: () {},
                    focusNode: AlwaysDisabledFocusNode(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*** Select the Date Of Birth ***";
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                  child: size.width > 600
                      ? Row(
                          children: [
                            Expanded(
                              child: MyTextFormField(
                                label: 'Telephone No.',
                                hint: 'Please enter phone number',
                                controller: phoneCtrl!,
                                prefixIcon: Icons.phone,
                                iconColor: Colors.indigo,
                                fontColor: Colors.black,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                  TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue))
                                ],
                                focusNode: AlwaysDisabledFocusNode(),
                                validator: (value) {
                                  if (value!.length >= 15 ||
                                      value.length <= 13) {
                                    return "${14 - value.length} digit more to go.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Expanded(
                              child: MyTextFormField(
                                label: 'Email ID',
                                hint: 'Please enter email id',
                                controller: emailCtrl!,
                                prefixIcon: Icons.email,
                                iconColor: Colors.indigo,
                                fontColor: Colors.black,
                                inputFormatter: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r"[a-zA-Z]+|\s")),
                                ],
                                focusNode: AlwaysDisabledFocusNode(),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "*** enter email id ***";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        )
                      : Column(children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                            child: MyTextFormField(
                              label: 'Telephone No.',
                              hint: 'Please enter phone number',
                              controller: phoneCtrl!,
                              prefixIcon: Icons.phone,
                              iconColor: Colors.indigo,
                              fontColor: Colors.black,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue))
                              ],
                              focusNode: AlwaysDisabledFocusNode(),
                              validator: (value) {
                                if (value!.length >= 15 || value.length <= 13) {
                                  return "${14 - value.length} digit more to go.";
                                }
                                return null;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                            child: MyTextFormField(
                              label: 'Email ID',
                              hint: 'Please enter email id',
                              controller: emailCtrl!,
                              prefixIcon: Icons.email,
                              iconColor: Colors.indigo,
                              fontColor: Colors.black,
                              inputFormatter: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r"[a-zA-Z]+|\s")),
                              ],
                              focusNode: AlwaysDisabledFocusNode(),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "*** enter email id ***";
                                }
                                return null;
                              },
                            ),
                          ),
                        ]
                      ),
                ),
                
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                  child: MyDropdownWidget(
                    focusNode: AlwaysDisabledFocusNode(),
                    disHint: Text(dropdownValue),
                    list: list1,
                    fontSize: size.width > 600 ? 25 : 15,
                    iconSize: size.width > 600 ? 25 : 15,
                    value: dropdownValue,
                    onChanged: null,
                    itemsList:
                        list1.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                  ),
                ),
                // RADIO WIDGET
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: MyRadioWidget(
                    fontSize: size.width > 600 ? 25 : 15,
                    groupVal: data!.gender,
                    onChanged: (val) {
                      setState(() {});
                    },
                  ),
                ),
                // CHECKBOX WIDGET
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: MyCheckBoxWidget(
                    fontSize: size.width > 600 ? 25 : 15,
                    val: data!.confirm,
                    onChanged: (value) {
                      return null;
                    },
                  ),
                ),
                // VIEW SIGNATURE BUTTON
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (_) =>
                              ImageDialog(path: data!.signatureImagePath!));
                    },
                    child: Text(
                      "View Signature",
                      style: TextStyle(
                        color: Colors.indigo,
                        fontSize: size.width > 600 ? 25 : 15),
                    ),
                  ),
                ),
                // EDIT BUTTON
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => MyEditFormPage(
                                        id: data!.id,
                                        name: data!.name,
                                        dob: data!.dob,
                                        phone: data!.phone,
                                        email: data!.email,
                                        expLevel: data!.expLevel,
                                        gender: data!.gender,
                                        confirm: data!.confirm,
                                        profileImagePath:
                                            data!.profileImagePath,
                                        signatureImagePath:
                                            data!.signatureImagePath,
                                      )));
                            },
                            child: Text('Edit',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: size.width > 600 ? 25 : 15))),
                      )
                    ],
                  ),
                ),
                // GENERATE PDF BUTTON
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          child: Text(
                            "Generate PDF",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: size.width > 600 ? 25 : 15
                            ),
                          ),
                          onPressed: () => onSubmit(
                              data!.signatureImagePath, context, data!),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Flexible(
                        flex: 2,
                        child: ElevatedButton(
                          child: Text(
                            "Send PDF To Email",
                            style: TextStyle(
                              color: Colors.indigo,
                              fontSize: size.width > 600 ? 25 : 15)
                          ),
                          onPressed: () => PdfApi.sendEmail(data!, context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  static Future onSubmit(signatureImagePath, context, employee) async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    final signatureImageBytes = await File(signatureImagePath).readAsBytes();
    final file = await PdfApi.generatePDF(
        employee: employee, signatureImageBytes: signatureImageBytes);

    // final wifiName = await UserNetworkInfo.getUserWifiName();
    // final wifiSignal = await UserNetworkInfo.getUserInternetSignal();
    // final wifiIP = await UserNetworkInfo.getUserWifiIP();
    // final wifiBroadcast = await UserNetworkInfo.getUserWifiBroadcast();
    // final wifiSubmask = await UserNetworkInfo.getUserWifiSubmask();
    // final wifiGatewayIP = await UserNetworkInfo.getUserWifiGatewayIP();
    // final osInfo = await OSInfo.osVersion();
    // print('************ WIFI Details ************');
    // print('wifiName: $wifiName');
    // print('wifiSignal: ${wifiSignal['WifiSignal']}');
    // print('mobileSignal: ${wifiSignal['MobileSignal']}');
    // print('wifiIP: $wifiIP');
    // print('wifiBroadcast: $wifiBroadcast');
    // print('wifiSubmask: $wifiSubmask');
    // print('wifiGatewayIP: $wifiGatewayIP');
    // print('************ WIFI Details ************');
    // print('\n');
    // print('************ Device Details ************');
    // print("Model: ${osInfo['Model']}");
    // print("Version: ${Platform.operatingSystem} ${osInfo['Version']}");
    // print("SDK: ${osInfo['SDK']}");
    // print("Manufacturer: ${osInfo['Manufacturer']}");
    // print('************ Device Details ************');

    Navigator.of(context).pop();
    if (await Permission.manageExternalStorage.request().isGranted) {
      await OpenFile.open(file.path);
    }
    else if (await Permission.storage.isGranted){
      await OpenFile.open(file.path);
    }
    else{
      showFlashError(context, "Permission is not granted");
    }
  }
}

class ImageDialog extends StatelessWidget {
  final String path;
  const ImageDialog({super.key, required this.path});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        width: 200,
        height: 200,
        decoration: BoxDecoration(
          image: DecorationImage(image: FileImage(File(path))),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
