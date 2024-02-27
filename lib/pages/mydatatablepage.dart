import 'package:flutter/material.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/pages/myviewformlargepage.dart';
import 'package:test_widgets/utils/utils.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/models/models.dart';

class MyDataTablePage extends StatelessWidget{
  const MyDataTablePage({super.key, required this.future});
  final Future<List<Employee>> future;

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Table View Page',
      fontSize: 25,
      iconSize: 40,
      width: 450,
      body: FutureBuilder<List<Employee>>(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Scaffold(
            body:SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: buildDataTable(context),
            ),
          );
        },
      ),
    );
  }

  Widget buildDataTable(context){
    final columns = ['ID', 'Name', 'DOB', 'Phone No.', 'Email', 'Experiece', 'Gender'];
    List<Employee>? data = objectbox.employeeBox.getAll();
    return DataTable(
      decoration: const BoxDecoration(
      ),
      dataRowMinHeight: 50,
      dataRowMaxHeight: 100,
      headingRowColor: MaterialStateProperty.all<Color>(Colors.grey),
      columns: getColumns(columns),
      rows: getRows(context, data),
    );
  }
  List<DataColumn> getColumns(List<String>columns){
    return columns.map((String column){
      return DataColumn(
        label: Text(column, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: Colors.indigo),),
      );
    }).toList();
  }
  
  List<DataRow> getRows(context, List<Employee> data) => data.map((Employee employee){
    final cells = [employee.id, employee.name, employee.dob, employee.phone, employee.email, employee.expLevel, employee.gender];
    return DataRow(
      cells: Utils.modelBuilder(cells, (index, cell) {
        return DataCell(
          Text('$cell', style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.indigo),),
          onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyViewFormLargePage(id: employee.id))),
        );
      }),
    );
  }).toList();
}
