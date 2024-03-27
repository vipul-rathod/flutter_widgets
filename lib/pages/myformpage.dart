import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/pages/mydatatablepage.dart';
import 'package:test_widgets/widgets/mycheckboxwidget.dart';
import 'package:test_widgets/widgets/mycreateprofileimage.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/mysignaturepage.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';
import 'package:email_validator/email_validator.dart';
import 'package:path/path.dart' as p;

List<String> list = ['Fresher', 'Mid Level', 'Senior Level'];

class MyFormPage extends StatefulWidget {
  const MyFormPage({super.key, this.onChanged});
  final Function(String?)? onChanged;

  @override
  State<MyFormPage> createState() => MyFormPageState();
}

class MyFormPageState extends State<MyFormPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  String? dropdownValue = list.first;
  bool? confirmationBool = false;
  String? genGroupVal = 'male';
  String? profileImage;
  bool isButtonPressed = false;
  String? pathToImage;
  String? tmpPath;
  Employee? employee;

  void showDatePickerTool() {
    var date = DateTime.now();
    showDatePicker(
      context: context,
      initialDate: DateTime(date.year - 21, date.month, date.day),
      firstDate: DateTime(date.year - 59),
      lastDate: DateTime(date.year - 21, date.month, date.day),
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
    String? tmpimgpath = await MyProfileImage.funcPath();
    return tmpimgpath;
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
  void initState() {
    super.initState();
    if (MySignaturePreviewPage.isActive == false) {
      MySignaturePreviewPage.signatureImagePath = '';
    }
    MySignaturePreviewPage.isActive = false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.topCenter,
      decoration:
          const BoxDecoration(color: Color.fromARGB(255, 225, 245, 245)),
      padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              const MyProfileImage(),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.all(8),
                // child: Expanded(
                  child: MyTextFormField(
                    label: 'Employee Name',
                    hint: 'Please enter name of employee',
                    controller: nameCtrl,
                    prefixIcon: Icons.people,
                    iconColor: Colors.indigo,
                    fontColor: Colors.black,
                    inputFormatter: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r"[a-zA-Z]+|\s")),
                      LengthLimitingTextInputFormatter(25),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "*** enter some text in the field ***";
                      } else {
                        return null;
                      }
                    },
                  ),
                // ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 0),
                // child: Expanded(
                  child: MyTextFormField(
                    label: 'Date Of Birth',
                    hint: 'Enter the date of birth',
                    controller: dobCtrl,
                    prefixIcon: Icons.calendar_today,
                    iconColor: Colors.indigo,
                    fontColor: Colors.black,
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
                // ),
              ),

              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 0),
                child: size.width > 600
                    ? Row(
                        children: <Widget>[
                          Expanded(
                            child: MyTextFormField(
                              label: 'Telephone No.',
                              hint: 'Please enter phone number',
                              controller: phoneCtrl,
                              prefixIcon: Icons.phone,
                              iconColor: Colors.indigo,
                              fontColor: Colors.black,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(10),
                                TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue))
                              ],
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value!.length >= 15 || value.length <= 13) {
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
                              controller: emailCtrl,
                              prefixIcon: Icons.email,
                              iconColor: Colors.indigo,
                              fontColor: Colors.black,
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
                          ),
                        ],
                      )
                    : Column(children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 10),
                          child: MyTextFormField(
                            label: 'Telephone No.',
                            hint: 'Please enter phone number',
                            controller: phoneCtrl,
                            prefixIcon: Icons.phone,
                            iconColor: Colors.indigo,
                            fontColor: Colors.black,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(10),
                              TextInputFormatter.withFunction((oldValue, newValue) => convert(oldValue, newValue))
                            ],
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.length >= 15 || value.length <= 13) {
                                return "${14 - value.length} digit more to go.";
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                          child: MyTextFormField(
                            label: 'Email ID',
                            hint: 'Please enter email id',
                            controller: emailCtrl,
                            prefixIcon: Icons.email,
                            iconColor: Colors.indigo,
                            fontColor: Colors.black,
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
                        ),
                      ]),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                child: MyDropdownWidget(
                  list: list,
                  fontSize: size.width > 600 ? 25 : 15,
                  iconSize: size.width > 600 ? 25 : 15,
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
                padding: const EdgeInsets.fromLTRB(8, 20, 8, 10),
                child: MyRadioWidget(
                    fontSize: size.width > 600 ? 25 : 15,
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
                  fontSize: size.width > 600 ? 25 : 15,
                  val: confirmationBool,
                  onChanged: (value) {
                    setState(() {
                      confirmationBool = value!;
                    });
                  },
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
                              // await Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MySignaturePage())).then((value) async {
                              tmpPath = await getImageFilePath();
                              if (tmpPath != null) {
                                if (context.mounted) {
                                  await Navigator.of(context)
                                      .push(MaterialPageRoute(
                                          builder: (context) =>
                                              const MySignaturePage()))
                                      .then((value) async {
                                    pathToImage = tmpPath.toString();
                                    String profileImageNameTmp =
                                        "${nameCtrl.text}-${p.basename(pathToImage!)}";
                                    String signatureImageNameTmp =
                                        "${nameCtrl.text}-${p.basename(MySignaturePreviewPage.signatureImagePath)}";
                                    employee = Employee(nameCtrl.text,
                                        dob: dobCtrl.text,
                                        phone: phoneCtrl.text,
                                        email: emailCtrl.text,
                                        expLevel: dropdownValue,
                                        gender: genGroupVal,
                                        confirm: confirmationBool,
                                        profileImageName: profileImageNameTmp,
                                        profileImagePath: pathToImage,
                                        signatureImageName:
                                            signatureImageNameTmp,
                                        signatureImagePath:
                                            MySignaturePreviewPage
                                                .signatureImagePath);
                                    objectbox.employeeBox.put(employee!);
                                    if (context.mounted) {
                                      MySignaturePreviewPage.isActive = false;
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MyDataTablePage(
                                                    future: getEmployees(),
                                                  )));
                                    }
                                  });
                                }
                              } else {
                                if (context.mounted) {
                                  showFlashError(
                                      context, "Please select profile image");
                                }
                              }
                            }
                            // }
                          },
                          child: Text('Submit',
                              style: TextStyle(
                                  color: Colors.indigo, fontSize: size.width > 600 ? 25 : 15))),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void showFlashError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}
