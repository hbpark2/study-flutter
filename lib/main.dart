// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:iclone/screens/feed.dart';
import 'package:iclone/stores/stores.dart';
import 'package:iclone/styles/style.dart' as style;
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:photofilters/photofilters.dart';
import 'package:image/image.dart' as imagelib;
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import 'notification.dart';
import 'screens/upload.dart';

// import 'package:flutter/rendering.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (c) => Store1()),
      ChangeNotifierProvider(create: (c) => Store2())
    ],
    child: MaterialApp(
      theme: style.theme,
      // initialRoute: '/',
      // routes: {
      //   '/': (c) => Text('페이지1'),
      //   '/detail': (c) => Text('페이지2'),
      // },
      home: MyApp(),
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int tab = 0;
  List feedData = [];
  var userImage;
  var userContent;

  var fileName;
  List<Filter> filters = presetFiltersList;
  final picker = ImagePicker();
  var imageFile;

  @override
  void initState() {
    super.initState();
    initNotification(context);
    saveData();
    getData();
  }

  saveData() async {
    var storage = await SharedPreferences.getInstance();
    var map = {'age': 20};
    storage.setString('map', jsonEncode(map));
    var result = storage.getString('map') ?? 'no data';
    print(jsonDecode(result));
  }

  addMyData() {
    var myData = {
      'id': feedData.length,
      'image': userImage,
      'likes': 4,
      'date': 'July',
      'content': userContent,
      'liked': false,
      'user': 'John Kim'
    };

    setState(() {
      feedData.insert(0, myData);
    });
  }

  setUserContent(a) {
    setState(() {
      userContent = a;
    });
  }

  Future getImage(context) async {
    if (imageFile == null) {
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFile = File(pickedFile.path);
        fileName = basename(imageFile.path);
        var image = imagelib.decodeImage(await imageFile.readAsBytes());
        if (image != null) {
          image = imagelib.copyResize(image, width: 600);
        }
        Map imagefile = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PhotoFilterSelector(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("필터", style: TextStyle(fontWeight: FontWeight.w300))
                ],
              ),
              appBarColor: Colors.white,
              image: image ?? imageFile,
              filters: presetFiltersList,
              filename: fileName,
              loader: Center(child: CircularProgressIndicator()),
              fit: BoxFit.contain,
            ),
          ),
        );

        if (imagefile.containsKey('image_filtered')) {
          setState(() {
            imageFile = imagefile['image_filtered'];
          });
          print(imageFile.path);
        }
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (c) => Upload(userImage: imageFile.path),
            ));
      }
    }
  }

  getData() async {
    var result = await http
        .get(Uri.parse('https://codingapple1.github.io/app/data.json'));
    if (result.statusCode == 200) {
      var result2 = jsonDecode(result.body);
      setState(() {
        feedData = result2;
      });
    } else {
      print('SERVER ERROR');
    }
  }

  fetchData(data) {
    setState(() {
      feedData.add(data);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Text('aa'),
        onPressed: () {
          // print(userImage);
          showNotification2();
        },
      ),
      appBar: AppBar(
        title: Text('Instagram'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_box_outlined),
            iconSize: 40,
            onPressed: () async {
              if (userImage == null) {
                var picker = ImagePicker();
                var image = await picker.pickImage(source: ImageSource.gallery);
                if (image != null) {
                  setState(() {
                    userImage = File(image.path);
                  });
                } else {
                  print('Something wrong');
                }
              }

              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => Upload(
                      userImage: userImage,
                      setUserContent: setUserContent,
                      addMyData: addMyData,
                    ),
                  ));
            },
            // onPressed: () => getImage(context),
            tooltip: 'Pick Image',
          ),
        ],
      ),
      body: [
        Home(feedData: feedData, fetchData: fetchData),
        Text('shop'),
      ][tab],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black.withOpacity(.40),
        currentIndex: tab,
        onTap: (value) => {
          setState(() {
            tab = value;
          })
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Shop',
          ),
        ],
      ),
    );
  }
}
