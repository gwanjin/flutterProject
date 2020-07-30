import 'package:flutter/material.dart';
import 'package:scheduleListApp/class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  // 入力文字列操作のコントローラー
  var _todoInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List', textAlign: TextAlign.center,),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    cursorColor: Colors.black,
                    controller: _todoInputController,
                  ),
                ),
                RaisedButton(
                  child: Text('追加'),
                  onPressed: (){
                    _addTodo(Todo(_todoInputController.text));
                  },
                ),
              ],
            ),
            // StreamBuilderで一部だけ描画
            StreamBuilder<QuerySnapshot>( // todo Collectionデータが入ってくるStreamを利用し、UIを描く
              // streamと連携しておいたら、stream値が変更されるたびにbuilderが呼び出される
              // snapshots()でstreamゲット、todo Collectionにある全てをstreamで読み込む
              stream: Firestore.instance.collection('todo').snapshots(), 
              builder: (context, snapshot) {  // UIを返却する
                if(!snapshot.hasData) { // データ有無判断
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data.documents; // 全ての情報をゲット
                return Expanded(
                  child: ListView(
                    children: documents.map((doc) => _buildItemWidget(doc)).toList(),
                  ),
                );
              }
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _todoInputController.dispose();
    super.dispose();
  }

  // FirestoreはDocumentSnapshotクラスのインスタンス
  Widget _buildItemWidget(DocumentSnapshot doc) {
    final todo = Todo(doc['title'], isDone: doc['isDone']);
    return ListTile(
      onTap: () {
        _toggleTodo(doc);
      },
      title: Text(
        todo.title,
        style: todo.isDone?TextStyle(
          decoration: TextDecoration.lineThrough, // キャンセル線
          fontStyle: FontStyle.italic,
        ): null,
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete_forever,), 
        onPressed: () {
          _deleteTodo(doc);
        }
      ),
    );
  }

  /// todo追加
  void _addTodo(Todo todo) {
    // todo Collectionへ追加
    Firestore.instance.collection('todo').add({'title':todo.title, 'isDone':todo.isDone});
    _todoInputController.text = '';
  }
  
  /// todo削除
  void _deleteTodo(DocumentSnapshot doc) {
    // documentIDを利用し、削除を行う。
    Firestore.instance.collection('todo').document(doc.documentID).delete();
  }

  /// todo完了/未完了
  void _toggleTodo(DocumentSnapshot doc) {
    // 特定のdocumentをアップデートするためにはdocumentIDが必要
    Firestore.instance.collection('todo').document(doc.documentID).updateData({'isDone':!doc['isDone']});
  }
}