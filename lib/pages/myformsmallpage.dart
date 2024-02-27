import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';

List<String> list = ['Fresher', 'Mid Level', 'Senior Level'];

class MyFormSmallPage extends StatefulWidget{
  const MyFormSmallPage({super.key});

  @override
  State<MyFormSmallPage> createState() => MyFormSmallPageState();
}

class MyFormSmallPageState extends State<MyFormSmallPage>{
  final formKey = GlobalKey<FormState>();
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController dobCtrl = TextEditingController();
  TextEditingController phoneCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  String? dropdownValue;
  
  var gender = 'male';
  var expLevel = 'Fresher';

  @override
  Widget build(BuildContext context){
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        color: const Color.fromARGB(255, 225, 245, 245),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: nameCtrl,
                          autocorrect: false,
                          maxLength: 25,
                          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"),)],
                          decoration: InputDecoration(
                            icon: const Icon(Icons.people, size: 25, color: Colors.indigo,),
                            suffixIcon: const Icon(Icons.check_circle, size: 40,),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.teal),
                              borderRadius: BorderRadius.circular(25)
                            ),
                            labelText: 'Employee Name',
                            labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo),
                            hintText: 'Please enter name of employee',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty){
                              return "Please enter some text in the field";
                            }
                            return null;
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                        ),
                    ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: dobCtrl,
                    focusNode: AlwaysDisabledFocusNode(),
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      icon: const Icon(Icons.calendar_today, size: 25, color: Colors.indigo,),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      labelText: 'Date Of Birth',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo),
                      hintText: 'Enter the date of birth',
                    ),
                    onTap: () {
                      void showDatePickerTool(){
                        showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime(1950), lastDate: DateTime(2025),).then((value){
                          if (value != null){
                            dobCtrl.text = '${value.day}-${value.month}-${value.year}';
                          }
                        });
                      }
                      showDatePickerTool();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,15,8, 10),
                  child: TextFormField(
                    controller: phoneCtrl,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10),
                    ],
                    decoration: InputDecoration(
                      icon: const Icon(Icons.phone, size: 25, color: Colors.indigo,),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      labelText: 'Telephone No.',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo),
                      hintText: 'Please enter phone number',
                    ),
                    validator: (value) {
                      if (value!.length >= 11 || value.length <= 9){
                        return "${10-value.length} digits more to go";
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,15,8, 10),
                  child: TextFormField(
                    controller: emailCtrl,
                    autocorrect: false,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"),)],
                    decoration: InputDecoration(
                      icon: const Icon(Icons.email, size: 25, color: Colors.indigo,),
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.teal),
                        borderRadius: BorderRadius.circular(25)
                      ),
                      labelText: 'Email ID.',
                      labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.indigo),
                      hintText: 'Please enter email id',
                    ),
                    validator: (value){
                      if (value!.isEmpty){
                        return 'Please enter a valid email id';
                      }
                      return null;
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(8,15,8, 10),
                  child: MyDropdownWidget(list: list, fontSize: 20, iconSize: 25, onChanged: (value){dropdownValue=value;})
                ),
                MyRadioWidget(
                  fontSize: 15,
                  onChanged: (value){
                    gender = value!;
                  }
                ),
              ],
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
