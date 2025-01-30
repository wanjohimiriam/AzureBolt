// import 'package:azure_bolt/devOpsController.dart';
// import 'package:azure_bolt/work_Item.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// void main() {
//   Get.put(DevOpsController());
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: WorkItemPage(),
//     );
//   }
// }
import 'package:azure_bolt/ml/task_creation.dart';
import 'package:azure_bolt/newClaude.dart';
import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Azure DevOps Automation',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TaskCreationForm(),
    );
  }
}
