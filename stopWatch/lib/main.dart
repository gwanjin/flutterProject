import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.black,
      ),
      home: StopWatchPage(title: 'StopWatch'),
    );
  }
}

class StopWatchPage extends StatefulWidget {
  final String title;
  StopWatchPage({Key key, this.title}) : super(key: key);

  @override
  _StopWatchPageState createState() => _StopWatchPageState();
}

class _StopWatchPageState extends State<StopWatchPage> {
  String _labResetButtonText = "ラップ";
  String _startPauseButtonText = "開始";
  Timer _timer;
  var _time = 0;
  var _isRunning = false;

  List<String> _labTimes = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    var min = '${_time ~/ 6000}'.padLeft(2, '0'); // ~/：商を求める
    var sec = '${_time ~/ 100}'.padLeft(2, '0'); 
    var milSec = '${_time%100}'.padLeft(2, '0');

    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text('$min', style: TextStyle(fontSize: 70),),
                Text(':', style: TextStyle(fontSize: 70),),
                Text('$sec', style: TextStyle(fontSize: 70),),
                Text(':', style: TextStyle(fontSize: 70),),
                Text('$milSec', style: TextStyle(fontSize: 70),),
              ],
            ),
            SizedBox(height: 40,),
            Container(
              margin: const EdgeInsets.only(left: 40, right: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      _clickLabResetButton();
                    },
                    child: _getLabResetIcon(_labResetButtonText),
                  ),
                  GestureDetector(
                    onTap: () {
                      _clickStartPauseButton();
                    },
                    child: _getStartPauseIcon(_startPauseButtonText),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Expanded(
              child: _buildBottom(),
            ),
          ],
        ),
      ),
    );
  }

  void _clickStartPauseButton() {
    _isRunning = !_isRunning;
    setState(() {
      if(_startPauseButtonText == '開始') {
        _startPauseButtonText = "停止";
        _labResetButtonText = "ラップ";
        _start();
      } else {
        _startPauseButtonText = "開始";
        _labResetButtonText = _time == 0 ? "ラップ":"リセット";
        _pause();
      }
    });
  }

  void _clickLabResetButton() {
    if(_labResetButtonText == "リセット") {
      _startPauseButtonText = "開始";
      _labResetButtonText = "ラップ";
      _reset();
    } else {
      _recordTime();
    }
  }

  Widget _getStartPauseIcon(String text) {
    if(text.compareTo('開始') == 0) {
      return Column(
        children: <Widget>[
          Icon(
            Icons.play_arrow,
            size: 100,
            color: Colors.green,
          ),
          Text('$text', style: TextStyle(fontSize: 20),),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Icon(
            Icons.stop,
            size: 100,
            color: Colors.red,
          ),
          Text('$text', style: TextStyle(fontSize: 20,),),
        ],
      );
    }
  }

  Widget _getLabResetIcon(String text) {
    if(text.compareTo('リセット') == 0) {
      return Column(
        children: <Widget>[
          Icon(
            Icons.refresh,
            size: 100,
          ),
          Text('$text', style: TextStyle(fontSize: 20),),
        ],
      );
    } else {
      return Column(
        children: <Widget>[
          Icon(
            Icons.add,
            size: 100,
          ),
          Text('$text', style: TextStyle(fontSize: 20,),),
        ],
      );
    }
  }

  void _start() {
    _timer = Timer.periodic(Duration(milliseconds: 10), (timer) {
      setState(() {
        _time++;
      });
    });
  }

  void _pause() {
    _timer?.cancel();
  }

  void _reset() {
    setState(() {
      _isRunning = false;
      _time = 0;
      _labTimes.clear();
      _timer?.cancel();
    });
  }

  // ラップタイム保存
  void _recordTime() {
    var min = '${_time ~/ 6000}'.padLeft(2, '0'); // ~/：商を求める
    var sec = '${_time ~/ 100}'.padLeft(2, '0'); 
    var milSec = '${_time%100}'.padLeft(2, '0');
    _labTimes.insert(0, '$min:$sec:$milSec');
  }

  @override
  void dispose() {
    _timer?.cancel(); // ?を付けたらnullをチェック
    super.dispose();
  }

  Widget _buildBottom() {
    final items = List.generate(_labTimes.length, (index) {
      return ListTile(
        leading: Text('ラップ${_labTimes.length-index}', style: TextStyle(fontSize: 25),),
        title: Text('${_labTimes[index]}', style: TextStyle(fontSize: 40),),
      );
    });

    return ListView(
      scrollDirection: Axis.vertical,
      children: items,
    );
  }
}