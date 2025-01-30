class TaskDetails {
  String title = '';
  String state = '';
  String priority = '';
  String complexity = '';
  String component = '';
  double confidence = 0.0;
  List<String> tags = [];
  String assignedTo = '';
  String sprint = '';
  String description = '';
  
  Map<String, dynamic> toJson() => {
    'title': title,
    'state': state,
    'priority': priority,
    'complexity': complexity,
    'component': component,
    'confidence': confidence,
    'tags': tags,
    'assignedTo': assignedTo,
    'sprint': sprint,
    'description': description,
  };

  static TaskDetails fromJson(Map<String, dynamic> json) {
    final details = TaskDetails()
      ..title = json['title'] ?? ''
      ..state = json['state'] ?? ''
      ..priority = json['priority'] ?? ''
      ..complexity = json['complexity'] ?? ''
      ..component = json['component'] ?? ''
      ..confidence = json['confidence']?.toDouble() ?? 0.0
      ..tags = List<String>.from(json['tags'] ?? [])
      ..assignedTo = json['assignedTo'] ?? ''
      ..sprint = json['sprint'] ?? ''
      ..description = json['description'] ?? '';
    return details;
  }
}