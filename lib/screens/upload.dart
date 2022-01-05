import 'package:flutter/material.dart';

class Upload extends StatelessWidget {
  const Upload(
      {Key? key,
      this.userImage,
      this.filters,
      this.setUserContent,
      this.addMyData})
      : super(key: key);
  final userImage;
  final filters;
  final setUserContent;
  final addMyData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {
              addMyData();
              Navigator.pop(context);
            },
          ),
        ]),
        body: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.close),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                // Text('이미지업로드화면'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // userImage == null ? Text('no image') : Image.file(userImage),
                    userImage == null
                        ? Text('no image')
                        : Image.file(
                            userImage,
                            width: MediaQuery.of(context).size.width * 0.8,
                          )
                  ],
                ),
                TextField(
                  onChanged: (text) {
                    setUserContent(text);
                  },
                ),
              ],
            )
          ],
        ));
  }
}
