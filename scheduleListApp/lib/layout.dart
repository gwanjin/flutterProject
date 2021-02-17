import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scheduleListApp/detail_layout.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class TodoListPage extends StatefulWidget {
  @override
  _TodoListPageState createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Todo',),
      ),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: <Widget>[
            // StreamBuilderで一部だけ描画
            StreamBuilder<QuerySnapshot>( // todo Collectionデータが入ってくるStreamを利用し、UIを描く
              // streamと連携しておいたら、stream値が変更されるたびにbuilderが呼び出される
              // snapshots()でstreamゲット、todo Collectionにある全てをstreamで読み込む
              // stream: Firestore.instance.collection('todo').orderBy("datetime").orderBy('title').snapshots(), 
              stream:  FirebaseFirestore.instance.collection('todo').orderBy('datetime').snapshots(),
              builder: (context, snapshot) {  // UIを返却する
                if(!snapshot.hasData) { // データ有無判断
                  return CircularProgressIndicator();
                }
                final documents = snapshot.data.docs; // 全ての情報をゲット
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
      floatingActionButton: FloatingActionButton(onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoPage(null)),);
      },
      child: Icon(Icons.add),
      ),
    );
  }

  // FirestoreはDocumentSnapshotクラスのインスタンス
  Widget _buildItemWidget(DocumentSnapshot doc) {
    String todoTitle = doc['title'];
    DateTime datetime = DateFormat('yyyy-MM-dd').parse(doc['datetime']);
    bool isDoneFlag = doc['isDone'];
    int color = doc['color'];
    
    return Slidable(
      actionPane: SlidableBehindActionPane(),
      actionExtentRatio: 0.2,
      child: Container(
        decoration: BoxDecoration(
          color: Color(color),
          shape: BoxShape.rectangle,
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.5,
            ),
          ),
        ),
        child: ListTile(
          onTap: () {
            _toggleTodo(doc);
          },
          title: Text(
            todoTitle,
            style: isDoneFlag?(TextStyle( decoration: TextDecoration.lineThrough, fontStyle: FontStyle.italic,)) : null,
          ),
          subtitle: Text(
            DateFormat('yyyy年 MM月 dd日').format(datetime),
            style: isDoneFlag?(TextStyle( decoration: TextDecoration.lineThrough, fontStyle: FontStyle.italic,)) : null,  
          ),
        ),
      ),
      actions: <Widget>[
        IconSlideAction(
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete_forever,
          onTap: () => {
            _deleteTodo(doc)
          },
        ),
        IconSlideAction(
          caption: 'Edit',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () => {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AddTodoPage(doc)),)
          },
        ),
      ],
    );
  }
  
  /// todo削除
  void _deleteTodo(DocumentSnapshot doc) {
    // documentIDを利用し、削除を行う。
    // Firestore.instance.collection('todo').document(doc.documentID).delete();
    FirebaseFirestore.instance.collection('todo').doc(doc.id).delete();
  }

  /// todo完了/未完了
  void _toggleTodo(DocumentSnapshot doc) {
    // 特定のdocumentをアップデートするためにはdocumentIDが必要
    // Firestore.instance.collection('todo').document(doc.documentID).updateData({'isDone':!doc['isDone']});
    FirebaseFirestore.instance.collection('todo').doc(doc.id).update({'isDone':!doc['isDone']});
  }
}

