import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/pages/mydatatablepage.dart';
import 'package:test_widgets/widgets/mycheckboxwidget.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';
import 'package:email_validator/email_validator.dart';


List<String> list = ['Fresher', 'Mid Level', 'Senior Level'];

class MyEditFormPage extends StatefulWidget{
  const MyEditFormPage({super.key, this.onChanged, required this.id, required this.name,
    required this.dob, required this.phone, required this.email, required this.expLevel, required this.gender, required this.confirm});

  final Function(String?)? onChanged;
  final int? id;
  final String? name;
  final String? dob;
  final String? phone;
  final String? email;
  final String? expLevel;
  final String? gender;
  final bool? confirm;

  @override
  State<MyEditFormPage> createState() => MyEditFormPageState(id, name, dob, phone, email, expLevel, gender, confirm);
}

class MyEditFormPageState extends State<MyEditFormPage>{
  int? updateID;
  String? name;
  String? dob;
  String? phone;
  String? email;
  String? expLevel;
  String? gender;
  bool? confirm;
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

  MyEditFormPageState(this.updateID, this.name, this.dob, this.phone, this.email, this.expLevel, this.gender, this.confirm);

  @override
  void initState() {
    super.initState();
    nameCtrl.text = name.toString();
    dobCtrl.text = dob.toString();
    phoneCtrl.text = phone.toString();
    emailCtrl.text = email.toString();
    dropdownValue = expLevel.toString();
    genGroupVal = gender.toString();
    confirmationBool = confirm;
  }

  void showDatePickerTool(){
    showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2025),).then((value){
      if (value != null){
        dobCtrl.text = '${value.day}-${value.month}-${value.year}';
      }
    });
  }

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  @override
  Widget build(BuildContext context){
    if (MediaQuery.of(context).size.width < 600){
      fontSize = 15;
      iconSize = 25;
      width = 300;
      screenWidth = MediaQuery.of(context).size.width;
    }
    else{
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
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 225, 245, 245)
        ),
        padding: const EdgeInsets.symmetric(
          vertical: 50,
          horizontal: 10
        ),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyTextFormField(label: 'Employee Name', hint: 'Please enter name of employee', 
                        controller: nameCtrl, 
                        prefixIcon: Icons.people, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, 
                        fontSize: fontSize!, inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))], 
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "*** enter some text in the field ***";
                          }
                          else{
                            return null;
                          }
                        },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8,0),
                  child: MyTextFormField(label: 'Date Of Birth', hint: 'Enter the date of birth', 
                    controller: dobCtrl,
                    prefixIcon: Icons.calendar_today,
                    iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, 
                    fontSize: fontSize!, onTap: () {showDatePickerTool();}, focusNode: AlwaysDisabledFocusNode(),
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return "*** Select the Date Of Birth ***";
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8,0),
                  child: screenWidth! > 600 ? Row(
                    children: [
                      MyTextFormField(label: 'Telephone No.', hint: 'Please enter phone number', 
                          controller: phoneCtrl,
                          prefixIcon: Icons.phone, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                          inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                          validator: (value){
                            if (value!.length >= 11 || value.length<=9){
                              return "${10 - value.length} digit more to go.";
                            }
                            return null;
                          },
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                      MyTextFormField(label: 'Email ID', hint: 'Please enter email id', 
                          controller: emailCtrl,
                          prefixIcon: Icons.email, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                          validator: (value){
                            final bool isValid = EmailValidator.validate(emailCtrl.text.toString());
                            if (!isValid){
                              return "*** enter email id ***";
                            }
                            if (value == null || value.isEmpty){
                              return "*** enter email id ***";
                            }
                            return null;
                          },
                        ),
                    ],
                  ) :
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,20,8,0),
                        child: MyTextFormField(label: 'Telephone No.', hint: 'Please enter phone number', 
                            controller: phoneCtrl,
                            prefixIcon: Icons.phone, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                            inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                            validator: (value){
                              if (value!.length >= 11 || value.length<=9){
                                return "${10 - value.length} digit more to go.";
                              }
                              return null;
                            },
                          ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8,20,8,0),
                        child: MyTextFormField(label: 'Email ID', hint: 'Please enter email id', 
                            controller: emailCtrl,
                            prefixIcon: Icons.email, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                            validator: (value){
                              final bool isValid = EmailValidator.validate(emailCtrl.text.toString());
                              if (!isValid){
                                return "*** enter email id ***";
                              }
                              if (value == null || value.isEmpty){
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
                  padding: const EdgeInsets.fromLTRB(8,20,8,10),
                  child: MyDropdownWidget(
                    list: list,
                    fontSize: fontSize!,
                    iconSize: iconSize!,
                    value: dropdownValue,
                    onChanged: (String? value){
                      setState(() {
                        dropdownValue=value!;
                      });
                    },
                    itemsList: list.map<DropdownMenuItem<String>>((String? value){
                      return DropdownMenuItem<String>(value: value, child: Text(value!),);
                      }).toList(),
                  ),
                ),

                Padding(padding: const EdgeInsets.fromLTRB(8,0,8,0),
                  child: MyRadioWidget(
                    fontSize: fontSize!,
                    groupVal: genGroupVal,
                    onChanged: (value) {
                      setState(() {
                        genGroupVal = value;
                      });
                    }
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                  child: MyCheckBoxWidget(
                    fontSize: fontSize!,
                    val: confirmationBool,
                    onChanged: (value){
                      setState(() {
                        confirmationBool=value!;
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                  child: Column(
                    children: <Widget>[SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()){
                          // print (nameCtrl.text);
                          Employee employee = Employee(nameCtrl.text, id: updateID!, dob: dobCtrl.text, phone: phoneCtrl.text, email: emailCtrl.text, expLevel: dropdownValue, gender: genGroupVal, confirm: confirmationBool);
                          objectbox.employeeBox.put(employee);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyDataTablePage(future: getEmployees(),)));
                        }
                      },
                      child: Text('Submit',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: fontSize!)
                        )
                      ),
                    )],
                  ),
                ),
              ],
            ),
          ),
        ),

      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => false;
}