import 'package:flutter/material.dart';
import 'notes_service.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() {
    return _NotesScreenState();
  }
}

class _NotesScreenState extends State<NotesScreen> {
  final controller = TextEditingController();
  final service = NotesService();

  List<String> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes(); 
  }

  /// Load saved notes
  void loadNotes() async {
    notes = await service.loadNotes();
    setState(() {});
  }

  /// Add new note
  void addNote() async {
    if (controller.text.trim().isEmpty) return;

    notes.add(controller.text.trim());
    controller.clear();

    await service.saveNotes(notes); 
    setState(() {});
  }

  /// Delete note (bonus feature 🔥)
  void deleteNote(int index) async {
    notes.removeAt(index);
    await service.saveNotes(notes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Notes',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// Input field
            TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: 'Add Note',
                prefixIcon: const Icon(Icons.note),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Add button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: addNote,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Add Note',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// Notes list
            Expanded(
              child: notes.isEmpty
                  ? const Center(
                      child: Text(
                        'No notes yet',
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: notes.length,
                      itemBuilder: (_, index) {
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ListTile(
                            title: Text(notes[index]),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => deleteNote(index),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}