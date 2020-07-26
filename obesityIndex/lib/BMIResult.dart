import 'package:flutter/material.dart';

class BMIResult extends StatelessWidget {
  final double height; // 身長
  final double weight; // 体重

  BMIResult(this.height, this.weight);

  @override
  Widget build(BuildContext context) {
    final bmi = weight / ((height / 100) * (height / 100));
    final displayBmi = bmi.toStringAsFixed(2);
    final recommandWeight = (((height / 100) * (height / 100)) * 22).toStringAsFixed(2);

    return Scaffold(
      appBar: AppBar(
        title: Text('BMI Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _calcBmi(bmi),
              style: TextStyle( fontSize: 36),
            ),
            SizedBox(height: 16.0,),
            _buildIcon(bmi),
            SizedBox(height: 16.0,),
            Text(
              'BMI 計算：$displayBmi',
              style: TextStyle( fontSize: 20),
            ),
            Text(
              '適性体重：$recommandWeight kg',
              style: TextStyle( fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
  
  String _calcBmi(double bmi) {
    var result = '低体重';
    if(bmi >= 40) {
      result = '肥満（４度）';
    } else if(bmi >= 35) {
      result = '肥満（３度）';
    } else if(bmi >= 30) {
      result = '肥満（２度）';
    } else if(bmi >= 25) {
      result = '肥満（１度）';
    } else if(bmi >= 18.5) {
      result = '普通体重';
    }
    return result;
  }

  Widget _buildIcon(double bmi) {
    if(bmi >= 25) {
      return Icon(
        Icons.sentiment_very_dissatisfied,
        color: Colors.red,
        size: 100,
      );
    } else if (bmi >= 18.5) {
      return Icon(
        Icons.sentiment_satisfied,
        color: Colors.green,
        size: 100,
      ); 
    } else {
      return Icon(
        Icons.sentiment_dissatisfied,
        color: Colors.orange,
        size: 100,
      ); 
    }
  }
}