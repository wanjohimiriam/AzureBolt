import 'package:azure_bolt/devOpsController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WorkItemPage extends StatelessWidget {
  final DevOpsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("Create Work Item"))),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Select Project:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => DropdownButton<String>(
                  value: controller.selectedProject.value,
                  items: controller.projects.map((String project) {
                    return DropdownMenuItem<String>(
                      value: project,
                      child:
                          Text(Uri.decodeFull(project)), // Convert %20 to space
                    );
                  }).toList(),
                  onChanged: (String? newProject) {
                    if (newProject != null) {
                      controller.updateProject(newProject);
                    }
                  },
                )),
            SizedBox(height: 10),
            Text("Select Person:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Obx(() => DropdownButton<String>(
                  value: controller.selectedPerson.value,
                  items: controller.person.map((String person) {
                    return DropdownMenuItem<String>(
                      value: person,
                      child:
                          Text(Uri.decodeFull(person)), // Convert %20 to space
                    );
                  }).toList(),
                  onChanged: (String? newPerson) {
                    if (newPerson != null) {
                      controller.updateProject(newPerson);
                    }
                  },
                )),
            SizedBox(height: 10),
            Text("Work Item Title:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: (value) => controller.updateTitle(value),
              decoration: InputDecoration(hintText: "Enter work item title"),
            ),
            SizedBox(height: 10),
            Text("Description:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              onChanged: (value) => controller.updateDescription(value),
              decoration:
                  InputDecoration(hintText: "Enter work item description"),
              maxLines: 3,
            ),
            SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.createWorkItem(),
                  child: controller.isLoading.value
                      ? CircularProgressIndicator()
                      : Text("Create Work Item"),
                )),
          ],
        ),
      ),
    );
  }
}
