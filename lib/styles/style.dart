import 'package:flutter/material.dart';

// 변수가 _로 시작하면 중복우려 x

var theme = ThemeData(
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    selectedItemColor: Colors.black,
  ),
  iconTheme: IconThemeData(
    color: Colors.black87,
  ),
  appBarTheme: AppBarTheme(
      color: Colors.white,
      elevation: 1,
      titleTextStyle: TextStyle(
          color: Colors.black87, fontWeight: FontWeight.w900, fontSize: 20),
      centerTitle: false,
      actionsIconTheme: IconThemeData(color: Colors.black87)),
);

var bodyItemStyle = ThemeData();
