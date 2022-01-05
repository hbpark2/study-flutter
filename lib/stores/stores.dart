import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Store1 extends ChangeNotifier {
  var follower = 0;
  var isFollow = false;
  var profileImage = [];

  getData() async {
    var result1 = await http
        .get(Uri.parse('https://codingapple1.github.io/app/profile.json'));

    var result2 = jsonDecode(result1.body);
    profileImage = result2;
    print(profileImage);
    notifyListeners();
  }

  toggleFollow() {
    if (isFollow) {
      follower--;
      isFollow = false;
    } else {
      follower++;
      isFollow = true;
    }
    notifyListeners();
  }
}

class Store2 extends ChangeNotifier {
  var name = 'jake park';
}
