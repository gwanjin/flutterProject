import 'package:flutter/material.dart';
import 'BMIResult.dart';
import 'package:flutter/services.dart';

class BMIMain extends StatefulWidget {
  BMIMain({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _BMIMainState createState() => _BMIMainState();
}

class _BMIMainState extends State<BMIMain> {
    // form widgetにユニクなキーを付与して検証時に使用
  final _formKey = GlobalKey<FormState>();
  
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();
  
  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey, // Form ウィジェットに keyを設定
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '身長',
                ),
                controller: _heightController,
                keyboardType: TextInputType.number,
                validator: (height) {
                  if(height.isEmpty) {
                    return '身長を入力してください。';
                  } else if(!RegExp("^[0-9]*(\.[0-9])?\$").hasMatch(height)) {
                    return '入力を確認してください。';
                  }
                  return null;
                },
              ),
              SizedBox(
                height: 16.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: '体重',
                ),
                controller: _weightController,
                keyboardType: TextInputType.number,
                validator: (weight) {
                  if(weight.isEmpty) {
                    return '身長を入力してください。';
                  } else if(!RegExp("^[0-9]*(\.[0-9])?\$").hasMatch(weight)) {
                    return '入力を確認してください。';
                  }
                  return null;
                },
              ),
              Container(
                margin: const EdgeInsets.only(top: 16.0),
                alignment: Alignment.centerRight,
                child: RaisedButton(
                  onPressed: () {
                    // Form入力値を確認するためにformKey設定が必要
                    if(_formKey.currentState.validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BMIResult(
                            double.parse(_heightController.text.trim()),
                            double.parse(_weightController.text.trim())
                          ),
                        ),
                      );
                    }
                  },
                  child: Text('BMI 確認'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}