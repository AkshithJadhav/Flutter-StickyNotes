// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:sticky_notes/google_sheets_api.dart';
import 'package:sticky_notes/loading_circle.dart';
import 'package:sticky_notes/my_button.dart';
import 'package:sticky_notes/notes_grid.dart';
import 'package:sticky_notes/textbox.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _refresh() async {
    startLoading();
    setState(() {});
    return await Future.delayed(const Duration(seconds: 1));
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => setState(() {}));
  }

  void _post() {
    GoogleSheetsApi.insert(_controller.text);
    _controller.clear();
    setState(() {});
  }

  //wait for the data to be fetched grom google slides
  void startLoading() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //start loading until the data arrives
    if (GoogleSheetsApi.loading == true) {
      startLoading();
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey[300],
        title: Text('S T I C K Y  N O T E S'),
        actions: [
          IconButton(
              onPressed: () {
                GoogleSheetsApi.delete();
                setState(() {});
              },
              icon: Icon(Icons.delete))
        ],
      ),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          Expanded(
            child: Container(
                child: GoogleSheetsApi.loading == true
                    ? LoadingCircle()
                    : NotesGrid()),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: 'Write a New Note',
                    suffixIcon: MyButton(
                      function: _post,
                    ),
                    labelText: 'New Note'),
              ),
            ),
          )
        ],
      ),
    );
  }
}
