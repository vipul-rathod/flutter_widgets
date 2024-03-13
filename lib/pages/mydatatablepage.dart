import 'package:flutter/material.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/pages/myviewformpage.dart';
import 'package:test_widgets/utils/utils.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/models/models.dart';

//ignore: must_be_immutable
class MyDataTablePage extends StatelessWidget{
  MyDataTablePage({super.key, required this.future});
  final Future<List<Employee>> future;
  double? fontSize;
  double? iconSize;
  double? width;

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    if (MediaQuery.of(context).size.width < 600){
      fontSize = 15;
      iconSize = 25;
      width = 300;
    }
    else{
      fontSize = 25;
      iconSize = 40;
      width = 450;
    }
    return MyScaffold(
      title: 'Table View Page',
      fontSize: fontSize!,
      iconSize: iconSize!,
      width: width!,
      body: FutureBuilder<List<Employee>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width * 5,
                  child: ListView(
                    children: [
                      buildDataTable(context),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildDataTable(context){
    final columns = [
      'ID',
      'Name',
      'DOB',
      'Phone No.',
      'Email',
      'Experiece',
      'Gender',
      'Profile Image Name',
      'Signature Image Name',
    ];
    List<Employee>? data = objectbox.employeeBox.getAll();
    return DataTable(
      decoration: const BoxDecoration(
        boxShadow: [BoxShadow(color: Colors.grey, offset: Offset(8, 8), blurRadius: 5),
                    BoxShadow(color: Colors.grey, offset: Offset(-8, -8), blurRadius: 5)]
      ),
      dataRowMinHeight: 30,
      dataRowMaxHeight: 50,
      dividerThickness: 2,
      border: TableBorder.all(width: 2, style: BorderStyle.solid),
      headingRowColor: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 178, 218, 244)),
      columns: getColumns(columns),
      rows: getRows(context, data),
    );
  }
  List<DataColumn> getColumns(List<String>columns){
    return columns.map((String column){
      return DataColumn(
        label: Text(column,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSize!*1.25,
            color: Colors.black),),
      );
    }).toList();
  }
  
  List<DataRow> getRows(context, List<Employee> data) => data.map((Employee employee){
    final cells = [
      employee.id,
      employee.name,
      employee.dob,
      employee.phone,
      employee.email,
      employee.expLevel,
      employee.gender,
      employee.profileImageName,
      employee.signatureImageName,
    ];

    return DataRow(
      color: MaterialStateProperty.all<Color>(const Color.fromARGB(255, 83, 123, 156)),
      cells: Utils.modelBuilder(cells, (index, cell) {
        return DataCell(
          Text('$cell',
            style: TextStyle(
              fontSize: fontSize!,
              fontWeight: FontWeight.bold,
              color: Colors.white
            ),
          ),
          placeholder: true,
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyViewFormPage(id: employee.id))),
        );
      }),
    );
  }).toList();
}
