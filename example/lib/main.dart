import 'package:example/models/department_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tab_sync/flutter_tab_sync.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home:  MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
   MyHomePage({super.key,});

  final List<DepartmentModel> departments=[
    DepartmentModel(name: 'Department1', employees: [
      'Wissam','Mohammad','Mikel','Ahmad'
    ],),
    DepartmentModel(name: 'Department2', employees: [
      'Max','Robin','Kareem','Toni','Lubna'
    ],),
    DepartmentModel(name: 'Department3', employees: [
      'Leen','Nour',
    ],),
    DepartmentModel(name: 'Department4', employees: [
      'Jessica','Luka','Antonio',
    ],),
    DepartmentModel(name: 'Department5', employees: [
      'Dani',
    ],),
    DepartmentModel(name: 'Department6', employees: [
      'Jessica','Luka','Antonio',
    ],),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueAccent.shade100,
      appBar: AppBar(
        title: const Text('Flutter Tab Async'),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,

      ),
      body: LabeledTabSyncView<DepartmentModel>(
        items: departments,
        itemBuilder: (department,isSelected)=>Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
            department.name,style: TextStyle(
              fontSize: 20,
          color: isSelected?Colors.white:Colors.black38,
        )),
            const SizedBox(height: 8,),
            ...department.employees.map((employee)=>ListTile(
                title: Text(
                  employee,style: TextStyle(color: isSelected?Colors.white:Colors.black38,),
                ),
            ))
          ],
        ),
        tabBuilder: (DepartmentModel item, bool isSelected)=>Text(
          item.name,style: TextStyle(
          fontSize: 12,
          color: isSelected?Colors.white:Colors.black38,
        ),
        ),

        labelStyle: LabelStyle(
        color: Colors.deepPurple,
        padding: const EdgeInsets.all(4),
        height: 32,
        borderRadius: BorderRadius.circular(4),
      ),
      ),
    );
  }
}
