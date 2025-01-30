import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../config/azure_config.dart';
import '../config/project_matcher.dart';

class TaskCreationForm extends StatefulWidget {
  const TaskCreationForm({super.key});

  @override
  TaskCreationFormState createState() => TaskCreationFormState();
}

class TaskCreationFormState extends State<TaskCreationForm> {
  final TextEditingController _descriptionController = TextEditingController();
  String _selectedProject = AzureConfig.PROJECTS.keys.first; // Initialize with a valid key
  String _selectedAssignee = '';
  List<String> _selectedTags = [];
  String _selectedSprint = '';
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    // Ensure _selectedProject is valid
    if (!AzureConfig.PROJECTS.containsKey(_selectedProject)) {
      throw Exception('Invalid project: $_selectedProject');
    }
    final projectConfig = AzureConfig.PROJECTS[_selectedProject]!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description field
            TextFormField(
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Task Description',
                hintText: 'Describe the task...',
              ),
              maxLines: 4,
              onChanged: (value) {
                // Auto-detect project based on description
                setState(() {
                  _selectedProject = ProjectMatcher.identifyProject(value);
                  // Reset selections when project changes
                  _selectedAssignee = AzureConfig.PROJECTS[_selectedProject]?.defaultAssignees.first ?? '';
                  _selectedTags = [];
                  _selectedSprint = AzureConfig.PROJECTS[_selectedProject]?.commonSprints.first ?? '';
                });
              },
            ),
            const SizedBox(height: 16),

            // Project dropdown
            DropdownButtonFormField<String>(
              value: _selectedProject,
              decoration: const InputDecoration(labelText: 'Project'),
              items: AzureConfig.PROJECTS.keys.map((String project) {
                return DropdownMenuItem<String>(
                  value: project,
                  child: Text(project),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedProject = newValue;
                    _selectedAssignee = AzureConfig.PROJECTS[newValue]?.defaultAssignees.first ?? '';
                    _selectedTags = [];
                    _selectedSprint = AzureConfig.PROJECTS[newValue]?.commonSprints.first ?? '';
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Assignee dropdown
            DropdownButtonFormField<String>(
              value: _selectedAssignee.isEmpty ? projectConfig.defaultAssignees.first : _selectedAssignee,
              decoration: const InputDecoration(labelText: 'Assignee'),
              items: projectConfig.defaultAssignees.map((String assignee) {
                return DropdownMenuItem<String>(
                  value: assignee,
                  child: Text(assignee),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedAssignee = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Tags multi-select
            const Text('Tags', style: TextStyle(fontSize: 16)),
            Wrap(
              spacing: 8,
              children: projectConfig.commonTags.map((String tag) {
                final isSelected = _selectedTags.contains(tag);
                return FilterChip(
                  label: Text(tag),
                  selected: isSelected,
                  onSelected: (bool selected) {
                    setState(() {
                      if (selected) {
                        _selectedTags.add(tag);
                      } else {
                        _selectedTags.remove(tag);
                      }
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Sprint dropdown
            DropdownButtonFormField<String>(
              value: _selectedSprint.isEmpty ? projectConfig.commonSprints.first : _selectedSprint,
              decoration: const InputDecoration(labelText: 'Sprint'),
              items: projectConfig.commonSprints.map((String sprint) {
                return DropdownMenuItem<String>(
                  value: sprint,
                  child: Text(sprint),
                );
              }).toList(),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedSprint = newValue;
                  });
                }
              },
            ),
            const SizedBox(height: 24),

            // Create button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _createTask,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _createTask() async {
    if (_descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a description')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final credentials = base64.encode(utf8.encode(':${AzureConfig.PAT}'));
      
      final response = await http.post(
        Uri.parse('https://dev.azure.com/${AzureConfig.ORGANIZATION}/project'),
        headers: {
          'Content-Type': 'application/json-patch+json',
          'Authorization': 'Basic $credentials',
        },
        body: jsonEncode([
          {
            "op": "add",
            "path": "/fields/System.Title",
            "value": _descriptionController.text.split('\n')[0], // First line as title
          },
          {
            "op": "add",
            "path": "/fields/System.Description",
            "value": _descriptionController.text,
          },
          {
            "op": "add",
            "path": "/fields/System.AssignedTo",
            "value": _selectedAssignee,
          },
          {
            "op": "add",
            "path": "/fields/System.State",
            "value": AzureConfig.PROJECTS[_selectedProject]!.defaultState,
          },
          {
            "op": "add",
            "path": "/fields/System.Tags",
            "value": _selectedTags.join('; '),
          },
          {
            "op": "add",
            "path": "/fields/System.IterationPath",
            "value": _selectedSprint,
          },
        ]),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Task created successfully!')),
        );
        _clearForm();
      } else {
        throw Exception('Failed to create task: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error creating task: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _clearForm() {
    _descriptionController.clear();
    setState(() {
      _selectedTags = [];
      _selectedSprint = AzureConfig.PROJECTS[_selectedProject]!.commonSprints.first;
    });
  }
}