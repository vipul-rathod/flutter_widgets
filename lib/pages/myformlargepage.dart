import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/pages/mylistpage.dart';
import 'package:test_widgets/widgets/mycheckboxwidget.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';

class MyFormLargePage extends StatefulWidget{
  const MyFormLargePage({super.key, this.onChanged});
  final Function(String?)? onChanged;

  @override
  State<MyFormLargePage> createState() => MyFormLargePageState();
}

class MyFormLargePageState extends State<MyFormLargePage>{
  final formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  var dropdownValue = list.first;
  var confirmationBool = false;
  String? genGroupVal = 'male';

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
    return MyScaffold(
      fontSize: 25,
      iconSize: 40,
      width: 450,
      title: 'Employee Registration Form',
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
                        controller: nameCtrl, prefixIcon: Icons.people, iconSize: 40, iconColor: Colors.indigo, fontColor: Colors.black, 
                        fontSize: 25, inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))],
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
                  padding: const EdgeInsets.fromLTRB(8,60,8, 10),
                  child: MyTextFormField(label: 'Date Of Birth', hint: 'Enter the date of birth',
                    controller: dobCtrl, prefixIcon: Icons.calendar_today,
                    iconSize: 40, iconColor: Colors.indigo, fontColor: Colors.black, 
                    fontSize: 25, onTap: () {showDatePickerTool();}, focusNode: AlwaysDisabledFocusNode(),
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return "*** Select the Date Of Birth ***";
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,60,8, 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: MyTextFormField(label: 'Telephone No.', hint: 'Please enter phone number',
                          controller: phoneCtrl, prefixIcon: Icons.phone, iconSize: 40, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: 25,
                          inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)],
                          validator: (value){
                            if (value!.length >= 11 || value.length<=9){
                              return "${10 - value.length} digit more to go.";
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: MyTextFormField(label: 'Email ID', hint: 'Please enter email id',
                          controller: emailCtrl, prefixIcon: Icons.email, iconSize: 40, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: 25,
                          inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),],
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return "*** enter email id ***";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,60,8, 10),
                  child: MyDropdownWidget(
                    list: list,
                    fontSize: 25,
                    iconSize: 40,
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
                Padding(padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                  child: MyRadioWidget(
                    fontSize: 25,
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
                    onChanged: (value){
                      confirmationBool=value;
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
                          Employee employee = Employee(nameCtrl.text, dob: dobCtrl.text, phone: phoneCtrl.text, email: emailCtrl.text, expLevel: dropdownValue, gender: genGroupVal, confirm: confirmationBool);
                          objectbox.employeeBox.put(employee);
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyListPage(future: getEmployees(),)));
                        }
                      },
                      child: const Text('Submit',
                        style: TextStyle(
                          color: Colors.indigo,
                          fontSize: 25)
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