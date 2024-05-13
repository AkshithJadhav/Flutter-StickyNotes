import 'package:flutter/material.dart';
import 'package:sticky_notes/google_sheets_api.dart';

import 'textbox.dart';

class NotesGrid extends StatelessWidget {
  const NotesGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: GoogleSheetsApi.currentNotes.length,
      gridDelegate:
          SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
      itemBuilder: (context, index) {
        return MyTextBox(text: GoogleSheetsApi.currentNotes[index]);
      },
    );
  }
}
