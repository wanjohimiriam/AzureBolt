
// Update TaskProcessor class
import 'package:azure_bolt/ml/task_classifier.dart';
import 'package:azure_bolt/ml/task_details.dart';


class TaskProcessor {
  final TaskClassifier _classifier = TaskClassifier();
  
  TaskDetails processDescription(String description) {
    final classifications = _classifier.classifyText(description);
    final details = TaskDetails()
      ..description = description
      ..title = _extractTitle(description)
      ..priority = _mapScore(classifications['priority'] ?? 0.5)
      ..complexity = _mapScore(classifications['complexity'] ?? 0.5)
      ..component = _mapComponent(classifications['component'] ?? 0.5)
      ..confidence = _calculateConfidence(classifications)
      ..state = _determineInitialState(classifications)
      ..tags = _generateTags(description, classifications)
      ..assignedTo = _suggestAssignee(description, classifications)
      ..sprint = _extractSprint(description);
    
    return details;
  }

  String _mapScore(double score) {
    if (score >= 0.7) return 'High';
    if (score >= 0.4) return 'Medium';
    return 'Low';
  }

  String _mapComponent(double score) {
    // Map the component score to the most likely component
    return 'Frontend'; // This would be based on your actual component mapping
  }

  double _calculateConfidence(Map<String, double> classifications) {
    // Average of all classification confidences
    return classifications.values.reduce((a, b) => a + b) / classifications.length;
  }

  String _determineInitialState(Map<String, double> classifications) {
    final priority = classifications['priority'] ?? 0.5;
    if (priority > 0.7) return 'Active';
    return 'New';
  }

  List<String> _generateTags(String description, Map<String, double> classifications) {
    Set<String> tags = {};
    
    // Add priority-based tag
    tags.add('priority-${_mapScore(classifications['priority'] ?? 0.5).toLowerCase()}');
    
    // Add component-based tag
    final component = _mapComponent(classifications['component'] ?? 0.5);
    tags.add(component.toLowerCase());
    
    return tags.toList();
  }

  String _suggestAssignee(String description, Map<String, double> classifications) {
    // Based on component and complexity, suggest an assignee
    final component = _mapComponent(classifications['component'] ?? 0.5);
    return '$component.team@company.com';
  }

  String _extractTitle(String description) {
    return description.split('.')[0].split('\n')[0].trim();
  }

  String _extractSprint(String description) {
    final sprintRegex = RegExp(r'sprint\s*(\d+)', caseSensitive: false);
    final match = sprintRegex.firstMatch(description);
    return match != null ? 'Sprint ${match.group(1)}' : '';
  }
}