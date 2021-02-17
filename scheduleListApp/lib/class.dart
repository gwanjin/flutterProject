class Todo {
  String datetime;
  String title;
  String memo;
  int color;
  bool isDone = false;
  

  Todo(this.title, this.memo, this.datetime, this.color, {this.isDone = false});
}