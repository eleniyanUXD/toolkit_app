import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});

  Map<String, dynamic> toJson() => {'title': title, 'isCompleted': isCompleted};

  factory Task.fromJson(Map<String, dynamic> json) =>
      Task(title: json['title'], isCompleted: json['isCompleted']);
}

class Service {
  static Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final tasksJson = tasks.map((task) => task.toJson()).toList();
    await prefs.setString('tasks', tasksJson.toString());
  }
}

class TaskScreen extends StatefulWidget {
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() {
    return _TaskScreenState();
  }
}

class _TaskScreenState extends State<TaskScreen> {
  List<Task> tasks = [
    Task(title: 'Sample Task 1'),
    Task(title: 'Sample Task 2'),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Task Manager',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      // Task manager body will go here
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          final task = tasks[index];

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              // Checkbox to mark task as completed
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (value) {
                  setState(() {
                    task.isCompleted = value!;
                  });
                  Service.saveTasks(tasks);
                },
              ),

              // Task text
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),

              // Edit & Delete button
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Edit button
                  IconButton(
                    icon: Icon(Icons.edit, color: Colors.blue),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                    },
                  ),

                  // Delete button
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        tasks.removeAt(index);
                      });
                      Service.saveTasks(tasks);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
