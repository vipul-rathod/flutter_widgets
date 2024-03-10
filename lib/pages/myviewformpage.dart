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

class MyViewFormPage extends StatefulWidget{
  final int? id;
  const MyViewFormPage({super.key, required this.id});

  @override
  State<MyViewFormPage> createState() => MyViewFormPageState();
}

class MyViewFormPageState extends State<MyViewFormPage>{
  final formKey = GlobalKey<FormState>();
  String dropdownValue = '';
  String genderValue = '';
  double? fontSize;
  double? iconSize;
  double? width;
  double? screenWidth;


  Employee? data;
  TextEditingController? nameCtrl;
  TextEditingController? dobCtrl;
  TextEditingController? phoneCtrl;
  TextEditingController? emailCtrl;
  List<String> list1 = [];

  @override
  void initState() {
    super.initState();
    data = objectbox.employeeBox.get(widget.id!);
    // data = objectbox.employeeBox.get(tempID!);
    nameCtrl = TextEditingController(text: data!.name.toString());
    dobCtrl = TextEditingController(text: data!.dob.toString());
    phoneCtrl = TextEditingController(text: data!.phone.toString());
    emailCtrl = TextEditingController(text: data!.email.toString());
    if (data?.expLevel != null){
      list1 = [data!.expLevel!];
    }
    else{
      list1 = ['Fresher'];
      debugPrint("expLevel is null");
    }
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
    setState((){
    dropdownValue = data!.expLevel.toString();
    genderValue = data!.gender.toString();
    });
    return MyScaffold(
      fontSize: fontSize!,
      iconSize: iconSize!,
      width: width!,
      title: 'View Form',
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
                MyProfileImage(imagelocalpath: data!.profileImage, viewmode: false,),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: MyTextFormField(label: 'Employee Name', hint: 'Please enter name of employee', 
                        controller: nameCtrl!,
                        prefixIcon: Icons.people, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, 
                        fontSize: fontSize!, inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s"))], focusNode: AlwaysDisabledFocusNode(),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,20,8, 0),
                  child: MyTextFormField(label: 'Date Of Birth', hint: 'Enter the date of birth', 
                    controller: dobCtrl!,
                    prefixIcon: Icons.calendar_today,
                    iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, 
                    fontSize: fontSize!, onTap: () {}, focusNode: AlwaysDisabledFocusNode(),
                    validator: (value){
                      if (value==null || value.isEmpty){
                        return "*** Select the Date Of Birth ***";
                      }
                      return null;
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,10,8, 0),
                  child: screenWidth! > 600 ? Row(
                    children: [
                      MyTextFormField(label: 'Telephone No.', hint: 'Please enter phone number', 
                          controller: phoneCtrl!,
                          prefixIcon: Icons.phone, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                          inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], focusNode: AlwaysDisabledFocusNode(),
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
                          controller: emailCtrl!,
                          prefixIcon: Icons.email, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                          inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),], focusNode: AlwaysDisabledFocusNode(),
                          validator: (value){
                            if (value == null || value.isEmpty){
                              return "*** enter email id ***";
                            }
                            return null;
                          },
                        ),
                    ],
                  ) : 
                  Column(
                    children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                      child: MyTextFormField(label: 'Telephone No.', hint: 'Please enter phone number', 
                        controller: phoneCtrl!,
                        prefixIcon: Icons.phone, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                        inputFormatter: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10)], focusNode: AlwaysDisabledFocusNode(),
                        validator: (value){
                          if (value!.length >= 11 || value.length<=9){
                            return "${10 - value.length} digit more to go.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(8,20,8, 10),
                      child: MyTextFormField(label: 'Email ID', hint: 'Please enter email id', 
                        controller: emailCtrl!,
                        prefixIcon: Icons.email, iconSize: iconSize!, iconColor: Colors.indigo, fontColor: Colors.black, fontSize: fontSize!,
                        inputFormatter: [FilteringTextInputFormatter.allow(RegExp(r"[a-zA-Z]+|\s")),], focusNode: AlwaysDisabledFocusNode(),
                        validator: (value){
                          if (value == null || value.isEmpty){
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
                  padding: const EdgeInsets.fromLTRB(8,20,8,10),
                  child: MyDropdownWidget(
                    focusNode: AlwaysDisabledFocusNode(),
                    disHint: Text(dropdownValue),
                    list: list1,
                    fontSize: fontSize!,
                    iconSize: iconSize!,
                    value: dropdownValue,
                    onChanged: null,
                    itemsList: list1.map<DropdownMenuItem<String>>((String? value){
                      return DropdownMenuItem<String>(value: value, child: Text(value!),);
                    }).toList(),
                  ),
                ),

                Padding(padding: const EdgeInsets.fromLTRB(8,0,8, 0),
                  child: MyRadioWidget(
                    fontSize: fontSize!,
                    groupVal: data!.gender,
                    onChanged: (val) {
                      setState(() {
                      });
                    },
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(8,0,8, 0),
                  child: MyCheckBoxWidget(
                    fontSize: fontSize!,
                    val: data!.confirm,
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
                      onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyEditFormPage(id: data!.id, name: data!.name, dob: data!.dob, phone: data!.phone, email: data!.email, expLevel: data!.expLevel, gender: data!.gender, confirm: data!.confirm, profileImage: data!.profileImage,)));},
                      child: Text('Edit',
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