import 'package:get/get.dart';
import 'package:note_taker_app/database/database_helper.dart';
import 'package:note_taker_app/model/note.dart';

class NoteController extends GetxController{
  RxList<Note> notes = <Note>[].obs;
  RxList<bool> checkedList = <bool>[].obs;

  Future<void> fetchNote() async{
    final fetchNotes = await DatabaseHelper().fetchNote();
    notes.assignAll(fetchNotes);
    checkedList.assignAll(List.generate(notes.length, (index)=>false));
  }

  Future<void> insertNote(Note note) async{
    await DatabaseHelper().insertNote(note);
    await fetchNote();
  }

  Future<void> updateNote(Note note) async{
    await DatabaseHelper().updateNote(note);
    await fetchNote();
  }

  void updateCheckedStatusbyIndex(int index) async{
    checkedList[index] = !checkedList[index];
  }

  bool canShowCheckBox(){
    return checkedList.contains(true);
  }

  Future<void> deleteMultipleNote() async{
    List<int> idList = [];
    for(int i =0;i<checkedList.length;i++){
      if(checkedList[i]) idList.add(notes[i].id!);
    }
    await DatabaseHelper().deleteMultipleNote(idList);
    await fetchNote();
  }

}