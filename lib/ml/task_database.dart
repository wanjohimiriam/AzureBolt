import 'package:azure_bolt/ml/task_classifier.dart';
import 'package:azure_bolt/ml/task_details.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class TaskDatabase {
  static Database? _database;
  
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'task_database.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            assigned_to TEXT,
            state TEXT,
            tags TEXT,
            sprint TEXT,
            predicted_tags TEXT,
            correct_tags TEXT,
            predicted_assignee TEXT,
            correct_assignee TEXT,
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
          )
        ''');
      },
    );
  }

  Future<void> saveTask(TaskDetails task, Map<String, String> predictions) async {
    final db = await database;
    await db.insert('tasks', {
      'title': task.title,
      'description': task.description,
      'assigned_to': task.assignedTo,
      'state': task.state,
      'tags': task.tags.join(';'),
      'sprint': task.sprint,
      'predicted_tags': predictions['tags'] ?? '',
      'predicted_assignee': predictions['assignee'] ?? '',
    });
  }

  Future<List<Map<String, dynamic>>> getTrainingData() async {
    final db = await database;
    return await db.query('tasks');
  }
}

