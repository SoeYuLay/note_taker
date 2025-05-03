import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:note_taker_app/controller/note_controller.dart';
import 'package:note_taker_app/view/manage_note.dart';

import '../model/note.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NoteController noteController = Get.put(NoteController());
  Widget buildCard(Note note, int index) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        SizedBox(
          width: double.infinity,
          child: InkWell(
            onTap: () {
              Get.to(ManageNote(note: note));
            },
            onLongPress: () {
              noteController.updateCheckedStatusbyIndex(index);
            },
            child: Card(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        note.title,
                        maxLines: 2,
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        note.description,
                        style: TextStyle(overflow: TextOverflow.ellipsis),
                        maxLines: 5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                        alignment: Alignment.centerLeft, child: Text(DateFormat('MMM d, yyyy').format(note.time),style: TextStyle(fontWeight: FontWeight.bold),)),
                  ),
                ],
              ),
            ),
          ),
        ),
        if (noteController.canShowCheckBox())
          Checkbox(
              value: noteController.checkedList[index],
              onChanged: (newValue) {
                noteController.updateCheckedStatusbyIndex(index);
              })
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    noteController.fetchNote();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx((){
      return Scaffold(
        appBar: AppBar(
          title: Text('My Note'),
          actions: [noteController.canShowCheckBox() ?
          IconButton(onPressed: () {
            noteController.deleteMultipleNote();
          }, icon: Icon(Icons.delete)): SizedBox()],
        ),
        body: Column(
          children: [
            Expanded(child: Obx(() {
              if(noteController.notes.isEmpty) return Center(child: Text('No Notes Yet'),);
              return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: noteController.notes.length,
                  itemBuilder: (context, index) {
                    return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Obx((){
                          return buildCard(noteController.notes[index], index);
                        })
                    );
                  });
            }))
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(ManageNote());
          },
          child: Icon(Icons.add),
        ),
      );
    });
  }
}
