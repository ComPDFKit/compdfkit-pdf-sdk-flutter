// Copyright © 2014-2025 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.
// example/lib/main.dart

import 'dart:io';
import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter/util/cpdf_file_util.dart';
import 'package:compdfkit_flutter_example/examples.dart';
import 'package:compdfkit_flutter_example/theme/themes.dart';
import 'package:compdfkit_flutter_example/utils/file_util.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_app_bar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  ThemeData _getLightTheme() => lightTheme;
  ThemeData _getDarkTheme() => darkTheme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComPDFKit SDK for Flutter',
      theme: _getLightTheme(),
      darkTheme: _getDarkTheme(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    _initializeComPDFKit();
  }

  Future<void> _initializeComPDFKit() async {
    await _initFontDir();
    await _initLicense();
  }

  Future<void> _initFontDir() async {
    final fontDir = await extractAssetFolder(context, 'extraFonts/');
    await ComPDFKit.setImportFontDir(fontDir, addSysFont: true);
  }

  Future<void> _initLicense() async {
    File licenseFile = await CPDFFileUtil.extractAsset('assets/license_key_flutter.xml', shouldOverwrite: false);
    final initResult = await ComPDFKit.initWithPath(licenseFile.path);
    debugPrint('AAA-ComPDFKit SDK init result: $initResult');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CAppBar(),
      body: ExampleListView(widgets: examples(context)),
    );
  }
}

class ExampleListView extends StatelessWidget {
  final List<Widget> widgets;

  const ExampleListView({super.key, required this.widgets});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (context, index) => widgets[index],
      ),
    );
  }
}
