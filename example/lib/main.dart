
import 'dart:math';

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

class MyHomePage extends StatefulWidget {
   MyHomePage({super.key,});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<DepartmentModel> departments=[
    DepartmentModel(name: 'Department1', employees: [
      'Wissam','Mohammad','Mikel','Ahmad'
    ],),
    DepartmentModel(name: 'Department2', employees: [
      'Max','Robin','Kareem','Toni','Lubna'
    ],),

    DepartmentModel(name: 'Department3', employees: [
      'Wissam','Mohammad','Mikel','Ahmad'
    ],),
    DepartmentModel(name: 'Department4', employees: [
      'Max','Robin','Kareem','Toni','Lubna'
    ],),

    DepartmentModel(name: 'Department5', employees: [
      'Wissam','Mohammad','Mikel','Ahmad'
    ],),
    DepartmentModel(name: 'Department6', employees: [
      'Max','Robin','Kareem','Toni','Lubna'
    ],),

    DepartmentModel(name: 'Department7', employees: [
      'Wissam','Mohammad','Mikel','Ahmad'
    ],),
    DepartmentModel(name: 'Department8', employees: [
      'Max','Robin','Kareem','Toni','Lubna'
    ],),

  ];

  ValueNotifier<int> selectedDepartment=ValueNotifier(0);
  void jumpToNext(){
    selectedDepartment.value=min(selectedDepartment.value+1,departments.length);
  }

  void jumpToPrevious(){
    selectedDepartment.value=max(0,selectedDepartment.value-1);
  }


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

      floatingActionButton:Row(
        mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ElevatedButton(onPressed: jumpToNext,child: Text('Next'),),
            ElevatedButton(onPressed: jumpToPrevious,child: Text('Previous'),),
          ],
      ),

      body: ValueListenableBuilder<int>(
    valueListenable: selectedDepartment,
    builder: (final _, final value,final __) => IndexedListSync<DepartmentModel>(
        items: departments,
        selectedIndex: value,

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

        ),
    ));
  }
}
