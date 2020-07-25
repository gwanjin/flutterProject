import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView( // スクロールが必要な場合のため
      children: <Widget>[
        _buildTop(),
        _buildMiddle(),
        _buildBottom(),
      ],
    );
  }

  Widget _buildTop() {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 20),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_taxi,
                      size: 40,
                    ),
                    Text('Taxi'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_pizza,
                      size: 40,
                    ),
                    Text('Pizza'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_post_office,
                      size: 40,
                    ),
                    Text('Post Office'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_parking,
                      size: 40,
                    ),
                    Text('Parking'),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),  //　余白追加
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_taxi,
                      size: 40,
                    ),
                    Text('Taxi'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_pizza,
                      size: 40,
                    ),
                    Text('Pizza'),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {

                },
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_post_office,
                      size: 40,
                    ),
                    Text('Post Office'),
                  ],
                ),
              ),
              Opacity(
                opacity: 0.0, // 透明
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.local_parking,
                      size: 40,
                    ),
                    Text('Parking'),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// 左右スライダー広告表示
  Widget _buildMiddle() {
    final dummyImage = [
      'https://cdn.pixabay.com/photo/2018/11/12/18/44/thanksgiving-3811492_1280.jpg',
      'https://cdn.pixabay.com/photo/2019/10/30/15/33/tajikistan-4589831_1280.jpg',
      'https://cdn.pixabay.com/photo/2019/11/25/16/15/safari-4652364_1280.jpg',
    ];

    return CarouselSlider(
      items: dummyImage.map((url) {
        return Builder(
          builder: (BuildContext context) {
            return Container(
              width: MediaQuery.of(context).size.width, // 端末の幅
              margin: EdgeInsets.symmetric(horizontal: 5.0), // 左右余白5
              decoration: BoxDecoration(
                color: Colors.amber,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.network(
                  url,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        );
      }).toList(),
      options: CarouselOptions(),
    );
  }

  Widget _buildBottom() {
    final items = List.generate(10, (index) {
      return ListTile(
        leading: Icon(Icons.notifications_none),
        title: Text('[Event] Notice $index'),
      );
    });

    return ListView(
      physics: NeverScrollableScrollPhysics(), // このリストについてスクロール動作禁止
      shrinkWrap: true, // このリストが他のスクロールオブジェクトの中にある場合、trueに設定する
      children: items,
    );
  }
}