import 'dart:convert';
import 'package:http/http.dart' as http;

class DevOpsService {
  final String organization = "IMPAXRND";
  final String pat = ""; // Store securely

  // List of projects
  final List<String> projects = [
    "Visitor%20Management",
    "Vendor%20Portals",
    "iTrack%20project",
    "Content%20Management%20System%20-%20Training%20School",
    "HR%20ESS%20E-Rec%20Portals",
    "Tenth%20liner",
    "KBL%20Middleware"
  ];
  final List<String> person = [
    "Jackiline Jeroitich",
    "Miriam Wanjohi",
    "Adrian Thuo",
    "Jackson Theuri",
    "Alex Kiija",
    "Kelvin Mukundi",
  ];

  // Function to create a new work item
  Future<bool> createWorkItem(String project, String person, String title, String description) async {
    String url =
        "https://dev.azure.com/$organization/$project/";

    final body = jsonEncode([
      {
        "op": "add",
        "path": "/fields/System.Title",
        "value": title,
      },
      {
        "op": "add",
        "path": "/fields/System.Description",
        "value": description,
      }
    ]);

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Authorization": "Basic ${base64Encode(utf8.encode(':$pat'))}",
        "Content-Type": "application/json-patch+json",
      },
      body: body,
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
