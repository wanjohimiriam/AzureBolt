import 'package:azure_bolt/ml/task_details.dart';
import 'package:flutter/material.dart';

class FeedbackDialog extends StatefulWidget {
  final TaskDetails details;

  const FeedbackDialog({super.key, required this.details});

  @override
  FeedbackDialogState createState() => FeedbackDialogState();
}

class FeedbackDialogState extends State<FeedbackDialog> {
  late TaskDetails correctedDetails;

  @override
  void initState() {
    super.initState();
    correctedDetails = TaskDetails()
      ..title = widget.details.title
      ..state = widget.details.state
      ..tags = List.from(widget.details.tags)
      ..assignedTo = widget.details.assignedTo
      ..sprint = widget.details.sprint
      ..description = widget.details.description;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Review Task Details'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: correctedDetails.title,
              decoration: const InputDecoration(labelText: 'Title'),
              onChanged: (value) => correctedDetails.title = value,
            ),
            TextFormField(
              initialValue: correctedDetails.assignedTo,
              decoration: const InputDecoration(labelText: 'Assigned To'),
              onChanged: (value) => correctedDetails.assignedTo = value,
            ),
            TextFormField(
              initialValue: correctedDetails.tags.join(', '),
              decoration: const InputDecoration(labelText: 'Tags'),
              onChanged: (value) => correctedDetails.tags = value.split(',').map((e) => e.trim()).toList(),
            ),
            TextFormField(
              initialValue: correctedDetails.sprint,
              decoration: const InputDecoration(labelText: 'Sprint'),
              onChanged: (value) => correctedDetails.sprint = value,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, correctedDetails),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}