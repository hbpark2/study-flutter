import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:iclone/screens/profile.dart';

class Home extends StatefulWidget {
  const Home({Key? key, this.feedData, this.fetchData}) : super(key: key);
  final feedData;
  final fetchData;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var scroll = ScrollController();
  var moreData = [];

  getMore() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/more1.json'));
    var result2 = jsonDecode(result.body);
    widget.fetchData(result2);
  }

  @override
  void initState() {
    super.initState();
    scroll.addListener(() {
      if (scroll.position.pixels == scroll.position.maxScrollExtent) {
        getMore();
      }
      /**
       * scroll.position.maxScrollExtent : 최대 스크롤 할 수 있는 높이 -> 전체높이
       * scroll.position.pixels : 스크롤한 정도
       * scroll.position.userScrollDirection : 스크롤 방향
       */
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.feedData.isNotEmpty) {
      return ListView.builder(
        controller: scroll,
        itemCount: widget.feedData.length,
        itemBuilder: (context, index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.feedData[index]['image'].runtimeType == String
                  ? Image.network(widget.feedData[index]['image'])
                  : Image.file(widget.feedData[index]['image']),
              Container(
                constraints:
                    BoxConstraints(maxWidth: MediaQuery.of(context).size.width),
                padding: EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      child: Text(widget.feedData[index]["user"]),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                pageBuilder: (c, a1, a2) => Profile(),
                                transitionsBuilder: (c, a1, a2, child) =>
                                    SlideTransition(
                                      position: Tween(
                                        begin: Offset(1.0, 0.0),
                                        end: Offset(0.0, 0.0),
                                      ).animate(a1),
                                      child: child,
                                    )));
                      },
                    ),
                    Text(
                      '좋아요 ${widget.feedData[index]["likes"].toString()}',
                    ),
                    Text(widget.feedData[index]["date"]),
                    Text(widget.feedData[index]["content"]),
                  ],
                ),
              ),
            ],
          );
        },
      );
    } else {
      return Text('loading');
    }
  }
}
