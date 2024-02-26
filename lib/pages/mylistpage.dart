import 'package:flutter/material.dart';
import 'package:test_widgets/main.dart';
import 'package:test_widgets/pages/myviewformlargepage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/models/models.dart';

class MyListPage extends StatelessWidget{
  const MyListPage({super.key, required this.future});
  final Future<List<Employee>> future;

  Future<List<Employee>> getEmployees() async {
    List<Employee> data = objectbox.employeeBox.getAll();
    return data;
  }

  Future<void> _showDialog(context, employee) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: const Text('Delete Dialog'),
          content: const SingleChildScrollView(
            child: Text('Are you sure to Delete from the database?'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                objectbox.employeeBox.remove(employee.id);
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyListPage(future: getEmployees(),)));
              },
              child: const Text('Yes')
            ),
            TextButton(
              onPressed: () {Navigator.of(context).pop();},
              child: const Text('No')
            ),
          ],
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'List View Page',
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
            body: ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index){
                final employee = snapshot.data![index];
                return buildEmployeeCard(employee, context);
              }
            ),
          );
        },
      ),
    );
  }

  Widget buildEmployeeCard(Employee employee, BuildContext context){
    return Card(
      color: Colors.white,
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(backgroundColor: Colors.tealAccent, child: Text('${employee.id}'),),
        title: Text(employee.name.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        subtitle: Text(employee.phone.toString()),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.deepOrangeAccent,),
          onPressed: () {
            _showDialog(context, employee);
          },
        ),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyViewFormLargePage(id: employee.id)));
        },
      ),
    );
  }
}
