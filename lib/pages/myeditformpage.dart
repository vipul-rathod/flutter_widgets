import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/pages/mydatatablepage.dart';
import 'package:test_widgets/widgets/mycheckboxwidget.dart';
import 'package:test_widgets/widgets/mycreateprofileimage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/mysignaturepage.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:path/path.dart' as p;

List<String> list = ['Fresher', 'Mid Level', 'Senior Level'];

class MyEditFormPage extends StatefulWidget {
  const MyEditFormPage(
      {super.key,
      this.onChanged,
      required this.id,
      required this.name,
      required this.dob,
      required this.phone,
      required this.email,
      required this.expLevel,
      required this.gender,
      required this.confirm,
      required this.profileImagePath,
      required this.signatureImagePath});

  final Function(String?)? onChanged;
  final int? id;
  final String? name;
  final String? dob;
  final String? phone;
  final String? email;
  final String? expLevel;
  final String? gender;
  final bool? confirm;
  final String? profileImagePath;
  final String? signatureImagePath;

  @override
  State<MyEditFormPage> createState() => MyEditFormPageState();
}

class MyEditFormPageState extends State<MyEditFormPage> {
  double? fontSize;
  double? iconSize;
  double? width;
  double? screenWidth;

  final formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  String? dropdownValue;
  bool? confirmationBool;
  String? genGroupVal;

  bool? isDeleted;

  @override
  void initState() {
    super.initState();
    nameCtrl.text = widget.name.toString();
    dobCtrl.text = widget.dob.toString();
    phoneCtrl.text = widget.phone.toString();
    emailCtrl.text = widget.email.toString();
    dropdownValue = widget.expLevel.toString();
    genGroupVal = widget.gender.toString();
    confirmationBool = widget.confirm;
    isDeleted = false;
  }

  void showDatePickerTool() {
    var date = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: DateTime(date.year-21, date.month, date.day),
      firstDate: DateTime(date.year-59),
      lastDate: DateTime(date.year-21, date.month, date.day),
    ).then((value) {
      if (value != null) {
        dobCtrl.text = '${value.day}-${value.month}-${value.year}';
      }
    });
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  Future<String?> getImageFilePath() async {
    String? getImagePath = await MyProfileImage.funcPaths(widget.profileImagePath);
    return getImagePath;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600) {
      fontSize = 15;
      iconSize = 25;
      width = 300;
      screenWidth = MediaQuery.of(context).size.width;
    } else {
      fontSize = 25;
      iconSize = 40;
      width = 450;
      screenWidth = MediaQuery.of(context).size.width;
    }
    return MyScaffold(
      fontSize: fontSize!,
      iconSize: iconSize!,
      width: width!,
      title: 'Edit Form',
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
                  imagelocalpath: widget.profileImagePath,
                  editmode: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyTextFormField(
                    label: 'Employee Name',
                    hint: 'Please enter name of employee',
                    controller: nameCtrl,
                    prefixIcon: Icons.people,
                    iconSize: iconSize!,
                    iconColor: Colors.indigo,
                    fontColor: Colors.black,
                    fontSize: fontSize!,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*** enter some text in the field ***";
                      } else {
                        return null;
                      }
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: MyTextFormField(
                    label: 'Date Of Birth',
                    hint: 'Enter the date of birth',
                    controller: dobCtrl,
                    prefixIcon: Icons.calendar_today,
                    iconSize: iconSize!,
                    iconColor: Colors.indigo,
                    fontColor: Colors.black,
                    fontSize: fontSize!,
                    onTap: () {
                      showDatePickerTool();
                    },
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
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                  child: screenWidth! > 600
                      ? Row(
                          children: [
                            MyTextFormField(
                              label: 'Telephone No.',
                              hint: 'Please enter phone number',
                              controller: phoneCtrl,
                              prefixIcon: Icons.phone,
                              iconSize: iconSize!,
                              iconColor: Colors.indigo,
                              fontColor: Colors.black,
                              fontSize: fontSize!,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10)
                              ],
                              validator: (value) {
                                if (value!.length >= 11 || value.length <= 9) {
                                  return "${10 - value.length} digit more to go.";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            MyTextFormField(
                              label: 'Email ID',
                              hint: 'Please enter email id',
                              controller: emailCtrl,
                              prefixIcon: Icons.email,
                              iconSize: iconSize!,
                              iconColor: Colors.indigo,
                              fontColor: Colors.black,
                              fontSize: fontSize!,
                              validator: (value) {
                                final bool isValid = EmailValidator.validate(
                                    emailCtrl.text.toString());
                                if (!isValid) {
                                  return "*** enter email id ***";
                                }
                                if (value == null || value.isEmpty) {
                                  return "*** enter email id ***";
                                }
                                return null;
                              },
                            ),
                          ],
                        )
                      : Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                              child: MyTextFormField(
                                label: 'Telephone No.',
                                hint: 'Please enter phone number',
                                controller: phoneCtrl,
                                prefixIcon: Icons.phone,
                                iconSize: iconSize!,
                                iconColor: Colors.indigo,
                                fontColor: Colors.black,
                                fontSize: fontSize!,
                                inputFormatter: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10)
                                ],
                                validator: (value) {
                                  if (value!.length >= 11 ||
                                      value.length <= 9) {
                                    return "${10 - value.length} digit more to go.";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                              child: MyTextFormField(
                                label: 'Email ID',
                                hint: 'Please enter email id',
                                controller: emailCtrl,
                                prefixIcon: Icons.email,
                                iconSize: iconSize!,
                                iconColor: Colors.indigo,
                                fontColor: Colors.black,
                                fontSize: fontSize!,
                                validator: (value) {
                                  final bool isValid = EmailValidator.validate(
                                      emailCtrl.text.toString());
                                  if (!isValid) {
                                    return "*** enter email id ***";
                                  }
                                  if (value == null || value.isEmpty) {
                                    return "*** enter email id ***";
                                  }
                                  return null;
                                },
                              ),
                            )
                          ],
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                  child: MyDropdownWidget(
                    list: list,
                    fontSize: fontSize!,
                    iconSize: iconSize!,
                    value: dropdownValue,
                    onChanged: (String? value) {
                      setState(() {
                        dropdownValue = value!;
                      });
                    },
                    itemsList:
                        list.map<DropdownMenuItem<String>>((String? value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value!),
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                  child: MyRadioWidget(
                      fontSize: fontSize!,
                      groupVal: genGroupVal,
                      onChanged: (value) {
                        setState(() {
                          genGroupVal = value;
                        });
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                  child: MyCheckBoxWidget(
                    fontSize: fontSize!,
                    val: confirmationBool,
                    onChanged: (value) {
                      setState(() {
                        confirmationBool = value!;
                      });
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 80,
                        backgroundImage:
                          File(widget.signatureImagePath!).existsSync() != false
                            ? isDeleted != true
                                ? FileImage(File(widget.signatureImagePath!))
                                : const AssetImage("assets/images/no_signature.webp") as ImageProvider
                            : const AssetImage("assets/images/no_signature.webp") as ImageProvider,
                        child: GestureDetector(
                          onTap: () async {
                            await showDialog(
                              context: context,
                              builder: (_) {
                                if (File(widget.signatureImagePath!).existsSync() != false){
                                  return ImageDialog(path: widget.signatureImagePath!);
                                }
                                else{
                                  return AlertDialog(
                                    title: const Text("No Signature Available"),
                                    actions: [
                                      ElevatedButton(
                                        onPressed: () {Navigator.of(context).pop();},
                                        child: const Text("ok"),
                                      ),
                                    ],
                                  );
                                }
                              }
                            );   
                          },
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: InkWell(
                          onTap: () async {
                              await showMyDialog(context, widget.signatureImagePath!);
                              isDeleted = true;

                          },
                          child: const Icon(
                            Icons.delete_forever,
                            color: Colors.teal,
                            size: 28,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                  child: Column(
                    children: <Widget>[
                      SizedBox(
                        width: 200,
                        height: 50,
                        child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final tmpPath = await getImageFilePath();
                                if (File(widget.signatureImagePath!).existsSync()){
                                  String profileImageNameTmp = "${nameCtrl.text}-${p.basename(tmpPath!)}";
                                  String signatureImageNameTmp = "${nameCtrl.text}-${p.basename(widget.signatureImagePath!)}";
                                  Employee employee = Employee(nameCtrl.text,
                                    id: widget.id!,
                                    dob: dobCtrl.text,
                                    phone: phoneCtrl.text,
                                    email: emailCtrl.text,
                                    expLevel: dropdownValue,
                                    gender: genGroupVal,
                                    confirm: confirmationBool,
                                    profileImageName: profileImageNameTmp,
                                    profileImagePath: tmpPath,
                                    signatureImageName: signatureImageNameTmp,
                                    signatureImagePath: widget.signatureImagePath!);

                                    objectbox.employeeBox.put(employee);
                                    if (context.mounted) {
                                      Navigator.of(context).push(MaterialPageRoute(
                                        builder: (context) => MyDataTablePage(
                                          future: getEmployees(),
                                        )
                                      )
                                    );
                                  }
                                }
                                else{
                                  if (context.mounted){
                                    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MySignaturePage())).then((value) async {
                                      String profileImageNameTmp = "${nameCtrl.text}-${p.basename(tmpPath!)}";
                                      String signatureImageNameTmp = "${nameCtrl.text}-${p.basename(MySignaturePreviewPage.signatureImagePath)}";
                                      Employee employee = Employee(nameCtrl.text,
                                        id: widget.id!,
                                        dob: dobCtrl.text,
                                        phone: phoneCtrl.text,
                                        email: emailCtrl.text,
                                        expLevel: dropdownValue,
                                        gender: genGroupVal,
                                        confirm: confirmationBool,
                                        profileImageName: profileImageNameTmp,
                                        profileImagePath: tmpPath,
                                        signatureImageName: signatureImageNameTmp,
                                        signatureImagePath: MySignaturePreviewPage.signatureImagePath);

                                      objectbox.employeeBox.put(employee);
                                      if (context.mounted) {
                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (context) => MyDataTablePage(
                                            future: getEmployees(),
                                            )
                                          )
                                        );
                                      }
                                    });
                                  }
                                }
                              }
                            },
                            child: Text('Submit',
                                style: TextStyle(
                                    color: Colors.indigo,
                                    fontSize: fontSize!))),
                      )
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
  Future<void> showMyDialog(context, signaturePath) async {
    if (File(signaturePath).existsSync()){
      return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete from database"),
          content: const SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Text("Are you sure, you want to delete Signature Image"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Confirm'),
              onPressed: () async {
                await deleteSignatureFile(signaturePath);
                setState(() {
                  Navigator.of(context).pop();
                });
              },
            ),
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      }
    );
    }
    else{
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Signature File not available"),
            actions: <Widget>[
              TextButton(
                child: const Text('Ok'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        }
      );
    }
  }
  deleteSignatureFile(signatureImagePath) {
    File file = File(signatureImagePath);
    file.delete().then((value) => debugPrint("Deleted"));
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
