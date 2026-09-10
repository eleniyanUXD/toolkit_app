import 'package:flutter/material.dart';
import '../services/notes_service.dart';
import '../services/recent_activity_service.dart';

class AddNotesScreen extends StatefulWidget {
  const AddNotesScreen({super.key});

  @override
  State<AddNotesScreen> createState() {
    return _AddNotesScreenState();
  }
}

class _AddNotesScreenState extends State<AddNotesScreen> {
  final controller = TextEditingController();
  final service = NotesService();

  List<String> notes = [];

  // Edit note index
  int? editingIndex;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  // Load saved notes
  Future<void> loadNotes() async {
    notes = await service.loadNotes();

    if (!mounted) return;

    setState(() {});
  }

  // Add or update note
  Future<void> addNote() async {
    final noteText = controller.text.trim();

    if (noteText.isEmpty) return;

    if (editingIndex != null) {
      notes[editingIndex!] = noteText;
      editingIndex = null;
    } else {
      notes.add(noteText);

      // Add to recent activity
      await RecentActivityService.addActivity(
        title: 'Add Note',
        subtitle: noteText,
        icon: 'note',
      );
    }

    controller.clear();

    await service.saveNotes(notes);

    if (!mounted) return;

    setState(() {});
  }

  void editNote(int index) {
    setState(() {
      controller.text = notes[index];
      editingIndex = index;
    });
  }

  // Delete note
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
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Edit button icon
                                IconButton(
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.blue,
                                  ),
                                  onPressed: () => editNote(index),
                                ),

                                // Delete button icon
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => deleteNote(index),
                                ),
                              ],
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
