class Todo {
  String? id;
  String text;
  bool isDone;

  Todo(this.text, this.isDone, [this.id]);

  Todo.fromJson(Map<String, dynamic> json)
    : id = json['_id'],
      text = json['text'],
      isDone = json['isDone'];

  Map<String, dynamic> toJson() => {
    'text': text,
    'isDone': isDone.toString(),
  };
}