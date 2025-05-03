import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:note_taker_app/controller/note_controller.dart';
import 'package:note_taker_app/model/note.dart';

class ManageNote extends StatefulWidget {

  const ManageNote({super.key, this.note});
  final Note? note;

  @override
  State<ManageNote> createState() => _ManageNoteState();
}

class _ManageNoteState extends State<ManageNote> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descController = TextEditingController();
  String? titleText;
  String? descriptionText;

  @override
  void initState() {
    // TODO: implement initState
    if(widget.note!=null){
      titleController.text = widget.note!.title;
      descController.text = widget.note!.description;
      titleText = titleController.text;
      descriptionText = descController.text;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note'),
        actions: [
          IconButton(
              onPressed: titleText!=null && descriptionText!=null && titleText!.isNotEmpty && descriptionText!.isNotEmpty ? () async{
                if(widget.note!=null){
                  await Get.find<NoteController>().updateNote(
                      Note(id: widget.note!.id, title: titleText!, description: descriptionText!,time: DateTime.now()));

                }else{
                  await Get.find<NoteController>().insertNote(
                      Note(title: titleText!, description: descriptionText!,time: DateTime.now()));
                }
                Navigator.of(context).pop();

              } : null,
              icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          children: [
            TextField(
              onChanged: (String? text){
                setState(() {
                  titleText = text;
                });
              },
              controller: titleController,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              maxLines: 3,
              style: TextStyle(
                  fontSize: 20, fontWeight: FontWeight.bold
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Title'
              ),
            ),
            TextField(
              onChanged: (String? text){
                setState(() {
                  descriptionText = text;
                });
              },
              controller: descController,
              maxLines: 10,
              keyboardType: TextInputType.text,
              textAlign: TextAlign.start,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Description'
              ),
            )
          ],
        ),
      ),
    );
  }
}
