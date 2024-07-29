// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
        primary: Color(0xFFFAFCFF),
        surface: Color(0xFFFAFCFF),
        onPrimary: Color(0xFF43474D),
        onSecondary: Color(0xFF666666)),
    textTheme: const TextTheme(
            bodyMedium: TextStyle(),
            bodyLarge: TextStyle(),
            bodySmall: TextStyle(),
            titleMedium: TextStyle())
        .apply(
            displayColor: const Color(0xFF43474D),
            bodyColor: const Color(0xFF43474D)),
    appBarTheme: const AppBarTheme(
        elevation: 4.0,
        titleTextStyle: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF43474D)),
        backgroundColor: Color(0xFFFAFCFF),
        foregroundColor: Color(0xFF43474D),
        systemOverlayStyle: SystemUiOverlayStyle(
            systemNavigationBarColor: Color(0xFFFFFFFF)
        )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.blue)));

final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: Colors.black,
    colorScheme: const ColorScheme.dark(
        primary: Color(0xFF222429),
        surface: Color(0xFF222429),
        onPrimary: Colors.white,
        onSecondary: Colors.white),
    textTheme: const TextTheme(
            bodyMedium: TextStyle(),
            bodyLarge: TextStyle(),
            bodySmall: TextStyle(),
            titleMedium: TextStyle())
        .apply(displayColor: Colors.white, bodyColor: Colors.white),
    appBarTheme: const AppBarTheme(
        elevation: 2.0,
        titleTextStyle: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        backgroundColor: Color(0xFF222429),
        foregroundColor: Colors.white,
    systemOverlayStyle: SystemUiOverlayStyle(
      systemNavigationBarColor: Color(0xFF222429)
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(foregroundColor: Colors.blue)));
