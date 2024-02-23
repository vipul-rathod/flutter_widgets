import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/widgets/mycheckboxwidget.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/widgets/myradiowidget.dart';
import 'package:test_widgets/widgets/mydropdownwidget.dart';
import 'package:test_widgets/widgets/mytextformfield.dart';
import 'package:test_widgets/main.dart';

List<String> list = ['Fresher', 'Mid Level', 'Senior Level'];
// enum Gender{male, female}

class MyViewFormLargePage extends StatefulWidget{
  final int id;
  const MyViewFormLargePage({super.key, required this.id});

  @override
  State<MyViewFormLargePage> createState() => MyViewFormLargePageState();
}

class MyViewFormLargePageState extends State<MyViewFormLargePage>{
  final formKey = GlobalKey<FormState>();
  String dropdownValue = '';
  Gender? gend;
  String gen_value = '';
  

  @override
  Widget build(BuildContext context){
    Employee? data = objectbox.employeeBox.get(widget.id);
    TextEditingController nameCtrl = TextEditingController(text: data!.name.toString());
    TextEditingController dobCtrl = TextEditingController(text: data.dob.toString());
    TextEditingController phoneCtrl = TextEditingController(text: data.phone.toString());
    TextEditingController emailCtrl = TextEditingController(text: data.email.toString());
    
    setState((){
    dropdownValue = data.expLevel.toString();
    gen_value = data.gender.toString();
    if (gen_value == 'male'){
      gend = Gender.male;
    }
    else{
      gend = Gender.female;
    }
    });
    
    
    

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
                        fontSize: 25, inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))], focusNode: AlwaysDisabledFocusNode(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,60,8, 10),
                  child: MyTextFormField(label: 'Date Of Birth', hint: 'Enter the date of birth',
                    controller: dobCtrl, prefixIcon: Icons.calendar_today,
                    iconSize: 40, iconColor: Colors.indigo, fontColor: Colors.black, 
                    fontSize: 25, onTap: () {}, focusNode: AlwaysDisabledFocusNode(),
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
                          inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], focusNode: AlwaysDisabledFocusNode(),
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
                          inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),], focusNode: AlwaysDisabledFocusNode(),
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
                    focusNode: AlwaysDisabledFocusNode(),
                    list: list,
                    fontSize: 25,
                    iconSize: 40,
                    value: dropdownValue,
                    itemsList: list.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(value: value, child: Text(value),);
                    }).toList(),
                  ),
                ),
                Padding(padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                  child: MyRadioWidget(
                    fontSize: 25,
                    val: gend,
                    onChanged: (val) {print(val);},
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                  child: MyCheckBoxWidget(
                    onChanged: (value){
                      return null;
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
                      onPressed: () {print(dropdownValue);},
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