import 'package:flutter/material.dart';
import 'package:test_widgets/pages/myviewformlargepage.dart';
import 'package:test_widgets/widgets/myscaffold.dart';
import 'package:test_widgets/models/models.dart';
import 'package:test_widgets/pages/myform.dart';

class MyListPage extends StatelessWidget{
  const MyListPage({super.key, required this.future});
  final Future<List<Employee>> future;

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'List View Page',
      fontSize: 40,
      iconSize: 40,
      width: 25,
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
            floatingActionButton: FloatingActionButton(
              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const MyForm()));},
              tooltip: 'Add Employee',
              child: const Icon(Icons.add),
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
        leading: CircleAvatar(backgroundColor: Colors.yellow, child: Text('${employee.id}'),),
        title: Text(employee.name.toString(), style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
        subtitle: Text(employee.phone.toString()),
        trailing: const Icon(Icons.delete, color: Colors.deepOrangeAccent,),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(builder: (context) => MyViewFormLargePage(id: employee.id)));
        },
      ),
    );
  }
}
