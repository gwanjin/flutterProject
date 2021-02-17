import 'package:flutter/material.dart';
import 'package:scheduleListApp/class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

class AddTodoPage extends StatefulWidget {
  AddTodoPage(this.doc);
  
  DocumentSnapshot doc;

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  // form widgetにユニクなキーを付与して検証時に使
  final _formKey = GlobalKey<FormState>();

    // 入力文字列操作のコントローラー
  var _todoInputController = TextEditingController();
  var _memoInputController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  int _colorValue = Colors.red[300].value;

  bool isEditable = false;
  bool isFirstChanged = false;

  @override
  Widget build(BuildContext context) {
    if(widget.doc != null && !isEditable) {
      _todoInputController.text = widget.doc['title'];
      _memoInputController.text = widget.doc['memo'];
      _selectedDate = DateFormat('yyyy-MM-dd').parse(widget.doc['datetime']);
      _colorValue = widget.doc['color'];
    }

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text((widget.doc != null)?(isEditable?'Todo Edit':'Todo Detail'):'Todo Add'),
        actions: <Widget>[
          if(widget.doc != null && isEditable)
            IconButton(icon: Icon(Icons.cancel, color: Colors.black,), onPressed: () {
              setState(() {
                isEditable = false;
              });
            })          
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 30,
                    alignment: Alignment.centerLeft,
                    child: Text('Title', style: TextStyle(fontSize:16.0, fontWeight:FontWeight.bold),),
                  ),
                  TextFormField(
                    readOnly: (widget.doc != null && !isEditable),
                    autofocus: (widget.doc == null || isEditable),
                    decoration: InputDecoration(hintText:'タイトルを登録してください。', border: OutlineInputBorder(), focusedBorder: OutlineInputBorder(),),
                    controller: _todoInputController,
                    validator: (title) {
                      if (title.isEmpty) return 'タイトルを入力してください。';
                      return null;
                    },
                    onChanged: (text) {
                      _formKey.currentState.validate();
                    },
                  ),
                  Padding(padding: const EdgeInsets.only(top:40, bottom: 10), child: Text('Memo', style: TextStyle(fontSize:16.0, fontWeight:FontWeight.bold),),),
                  Container(
                    height: MediaQuery.of(context).size.height*0.2,
                    padding: EdgeInsets.only(left: 5.0, right: 5.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.7,
                      ),
                    ),
                    child: TextField(
                      readOnly: (widget.doc != null && !isEditable),
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      controller: _memoInputController,
                      textAlign: TextAlign.left,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top:40, bottom: 10), child: Text('Date', style: TextStyle(fontSize:16.0, fontWeight:FontWeight.bold),),),
                  OutlineButton(
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width/2.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Icon(Icons.calendar_today),
                          Text(DateFormat('yyyy年 MM月 dd日').format(_selectedDate)),
                        ],
                      ),
                    ),
                    onPressed: (widget.doc != null && !isEditable)?null:() {
                      FocusScope.of(context).unfocus();
                      Future<DateTime> calendar = showDatePicker(context: context, initialDate: _selectedDate, firstDate: DateTime(2020), lastDate: DateTime(2050));
                      calendar.then((date) {
                        setState(() {
                          _selectedDate = date==null?_selectedDate:date;
                        });
                      });
                    },
                  ),
                  Padding(padding: const EdgeInsets.only(top:40, bottom: 10), child: Text('Tag', style: TextStyle(fontSize:16.0, fontWeight:FontWeight.bold),),),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      GestureDetector(
                        onTap: (widget.doc != null && !isEditable)?null:() => _colorSelect(Colors.red[300].value),
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.red[300],
                          ),
                          child:(_colorValue == Colors.red[300].value)?Icon(Icons.check, color: Colors.white,):null,
                        ),
                      ),
                      GestureDetector(
                        onTap: (widget.doc != null && !isEditable)?null:() => _colorSelect(Colors.green[100].value),
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.green[100],
                          ),
                          child:(_colorValue == Colors.green[100].value)?Icon(Icons.check, color: Colors.white,):null,
                        ),
                      ),
                      GestureDetector(
                        onTap: (widget.doc != null && !isEditable)?null:() => _colorSelect(Colors.pink[100].value),
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink[100],
                          ),
                          child:(_colorValue == Colors.pink[100].value)?Icon(Icons.check, color: Colors.white,):null,
                        ),
                      ),
                      GestureDetector(
                        onTap: (widget.doc != null && !isEditable)?null:() => _colorSelect(Colors.orange[200].value),
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.orange[200],
                          ),
                          child:(_colorValue == Colors.orange[200].value)?Icon(Icons.check, color: Colors.white,):null,
                        ),
                      ),
                      GestureDetector(
                        onTap: (widget.doc != null && !isEditable)?null:() => _colorSelect(Colors.purple[200].value),
                        child: Container(
                          height: MediaQuery.of(context).size.width*0.15,
                          width: MediaQuery.of(context).size.width*0.15,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.purple[200],
                          ),
                          child:(_colorValue == Colors.purple[200].value)?Icon(Icons.check, color: Colors.white,):null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (widget.doc == null) {
            if (_formKey.currentState.validate()) {
              _addTodo(Todo(_todoInputController.text, _memoInputController.text, _selectedDate.toString(), _colorValue));
              Navigator.pop(context);
            }
          } else if(isEditable) {
            if (_formKey.currentState.validate()) {
              _updateTodo(widget.doc, Todo(_todoInputController.text, _memoInputController.text, _selectedDate.toString(), _colorValue));
              Navigator.pop(context);
            }
          } else {
            setState(() {
              isEditable = true;
            });
          }
        },
        icon: (widget.doc == null)?Icon(Icons.add):isEditable?Icon(Icons.save_alt):Icon(Icons.edit),
        label: (widget.doc == null)? const Text('Todo Add'):isEditable?const Text('Save'):const Text('Edit'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  void _colorSelect(int color) {
    setState(() {
      print("setState color : $color");
      _colorValue = color;
    });
  }
  
  /// todo追加
  void _addTodo(Todo todo) {
    // todo Collectionへ追加
    // Firestore.instance.collection('todo').add({'datetime':todo.datetime, 'title':todo.title, 'memo':todo.memo, 'color':todo.color, 'isDone':todo.isDone});
    FirebaseFirestore.instance.collection('todo').add({'datetime':todo.datetime, 'title':todo.title, 'memo':todo.memo, 'color':todo.color, 'isDone':todo.isDone});
    _todoInputController.text = '';
    _memoInputController.text = '';
  }

  /// todo完了/未完了
  void _updateTodo(DocumentSnapshot doc, Todo todo) {
    // 特定のdocumentをアップデートするためにはdocumentIDが必要
    // Firestore.instance.collection('todo').document(doc.documentID).updateData({'datetime':todo.datetime, 'title':todo.title, 'memo':todo.memo, 'color':todo.color});
    FirebaseFirestore.instance.collection('todo').doc(doc.id).update({'datetime':todo.datetime, 'title':todo.title, 'memo':todo.memo, 'color':todo.color});
  }

  @override
  void dispose() {
    _todoInputController.dispose();
    _memoInputController.dispose();
    super.dispose();
  }
}