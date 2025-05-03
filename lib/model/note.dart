class Note {
  int? id;
  String title;
  String description;
  DateTime time;

  Note({this.id, required this.title, required this.description,required this.time});

  Map<String,dynamic> toJson(){
    return {
      'title' : title,
      'description' : description,
      'time' : time.toIso8601String()
    };
  }

  factory Note.fromJson(Map<String,dynamic> json){
    return Note(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        time: DateTime.parse(json['time'])
    );
  }
}
