// // // pubspec.yaml
// // name: azure_devops_automation
// // description: Automates creation of Azure DevOps work items
// // dependencies:
// //   flutter:
// //     sdk: flutter
// //   http: ^1.1.0
// //   flutter_secure_storage: ^9.0.0

// // lib/main.dart
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Azure DevOps Automation',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const TaskCreationForm(),
//     );
//   }
// }
// // 7Vn7980ghhimNUM8ZBGWr0Ydw2A1XFFV3c9AtjC00fMTCqAB3T68JQQJ99BAACAAAAAbY0nVAAASAZDOd6cG

// class TaskCreationForm extends StatefulWidget {
//   const TaskCreationForm({super.key});

//   @override
//   TaskCreationFormState createState() => TaskCreationFormState();
// }

// class TaskCreationFormState extends State<TaskCreationForm> {
//   final _formKey = GlobalKey<FormState>();
//   final _storage = FlutterSecureStorage();
  
//   final TextEditingController _personController = TextEditingController();
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _stateController = TextEditingController();
//   final TextEditingController _tagController = TextEditingController();
//   final TextEditingController _sprintController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _patController = TextEditingController();
  
//   String? _savedPat;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _loadPat();
//   }

//   Future<void> _loadPat() async {
//     _savedPat = await _storage.read(key: 'azure_pat');
//     if (_savedPat != null) {
//       _patController.text = _savedPat!;
//     }
//   }

//   Future<void> _savePat(String pat) async {
//     await _storage.write(key: 'azure_pat', value: pat);
//   }

//   Future<void> _createTask() async {
//     if (!_formKey.currentState!.validate()) return;

//     setState(() {
//       _isLoading = true;
//     });

//     try {
//       final credentials = base64.encode(utf8.encode(':${_patController.text}'));
      
//       final response = await http.post(
//         Uri.parse('https://dev.azure.com/IMPAXRND/_apis/wit/workitems/\$Task?api-version=7.0'),
//         headers: {
//           'Content-Type': 'application/json-patch+json',
//           'Authorization': 'Basic $credentials',
//         },
//         body: jsonEncode([
//           {
//             "op": "add",
//             "path": "/fields/System.Title",
//             "value": _titleController.text
//           },
//           {
//             "op": "add",
//             "path": "/fields/System.AssignedTo",
//             "value": _personController.text
//           },
//           {
//             "op": "add",
//             "path": "/fields/System.State",
//             "value": _stateController.text
//           },
//           {
//             "op": "add",
//             "path": "/fields/System.Tags",
//             "value": _tagController.text
//           },
//           {
//             "op": "add",
//             "path": "/fields/System.IterationPath",
//             "value": _sprintController.text
//           },
//           {
//             "op": "add",
//             "path": "/fields/System.Description",
//             "value": _descriptionController.text
//           }
//         ]),
//       );

//       if (response.statusCode == 200) {
//         _savePat(_patController.text);
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Task created successfully!')),
//         );
//         _clearForm();
//       } else {
//         throw Exception('Failed to create task: ${response.statusCode}');
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error creating task: $e')),
//       );
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   void _clearForm() {
//     _titleController.clear();
//     _personController.clear();
//     _stateController.clear();
//     _tagController.clear();
//     _sprintController.clear();
//     _descriptionController.clear();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Create Azure DevOps Task'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Form(
//           key: _formKey,
//           child: ListView(
//             children: [
//               TextFormField(
//                 controller: _patController,
//                 decoration: const InputDecoration(
//                   labelText: 'Personal Access Token (PAT)',
//                   hintText: 'Enter your Azure DevOps PAT',
//                 ),
//                 obscureText: true,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter your PAT';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _personController,
//                 decoration: const InputDecoration(
//                   labelText: 'Assigned To',
//                   hintText: 'Enter person email or name',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter assignee';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _titleController,
//                 decoration: const InputDecoration(
//                   labelText: 'Title',
//                   hintText: 'Enter task title',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter title';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _stateController,
//                 decoration: const InputDecoration(
//                   labelText: 'State',
//                   hintText: 'Enter task state',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter state';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _tagController,
//                 decoration: const InputDecoration(
//                   labelText: 'Tags',
//                   hintText: 'Enter tags (semicolon-separated)',
//                 ),
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _sprintController,
//                 decoration: const InputDecoration(
//                   labelText: 'Sprint',
//                   hintText: 'Enter sprint name',
//                 ),
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter sprint';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 16),
//               TextFormField(
//                 controller: _descriptionController,
//                 decoration: const InputDecoration(
//                   labelText: 'Description',
//                   hintText: 'Enter task description',
//                 ),
//                 maxLines: 4,
//                 validator: (value) {
//                   if (value == null || value.isEmpty) {
//                     return 'Please enter description';
//                   }
//                   return null;
//                 },
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: _isLoading ? null : _createTask,
//                 child: _isLoading
//                     ? const CircularProgressIndicator()
//                     : const Text('Create Task'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }