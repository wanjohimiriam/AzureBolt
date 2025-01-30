import 'package:azure_bolt/devOpsService.dart';
import 'package:get/get.dart';

class DevOpsController extends GetxController {
  final DevOpsService _devOpsService = DevOpsService();

  var selectedProject = "Visitor%20Management".obs;
  var selectedPerson = "Jackiline Jeroitich".obs;
  var title = "".obs;
  var description = "".obs;
  var isLoading = false.obs;

  // List of available projects
  List<String> get projects => _devOpsService.projects;
  List<String> get person => _devOpsService.person;

  // Update project selection
  void updateProject(String project) {
    selectedProject.value = project;
  }
  void updatePerson(String person) {
    selectedPerson.value = person;
  }

  // Update title & description
  void updateTitle(String newTitle) {
    title.value = newTitle;
  }

  void updateDescription(String newDescription) {
    description.value = newDescription;
  }

  // Create work item
  void createWorkItem() async {
    if (title.isEmpty || description.isEmpty) {
      Get.snackbar("Error", "Title and Description are required!");
      return;
    }

    isLoading.value = true;
    bool success = await _devOpsService.createWorkItem(
      selectedPerson.value, selectedProject.value, title.value, description.value
    );
    isLoading.value = false;

    if (success) {
      Get.snackbar("Success", "Work item created successfully!");
      title.value = "";
      description.value = "";
    } else {
      Get.snackbar("Error", "Failed to create work item");
    }
  }
}
