// Copyright © 2014-2024 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/compdfkit.dart';
import 'package:compdfkit_flutter_example/examples.dart';
import 'package:compdfkit_flutter_example/theme/themes.dart';
import 'package:compdfkit_flutter_example/widgets/cpdf_app_bar.dart';

import 'package:flutter/material.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ComPDFKit SDK for Flutter',
      theme: lightTheme,
      darkTheme: darkTheme,
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
    _init();
  }

  void _init() async {
    // online license auth
    // Please replace it with your ComPDFKit license
    // ComPDFKit.initialize(androidOnlineLicense: 'IVTAsbJCW0X45qIy5cTEuzxZzKpYIpJe6WPY7uCPIiI=',iosOnlineLicense: 'lkw3Gr0HuD5pV1/+DVRSxp7qBlvK+Izo3mOKyAEHXz4=');

    // offline license auth
    ComPDFKit.init('2sAQ0T0o6skMlaNcW3NnvLzUkm0a4CRoLrGDn0hKWgA2mW0XKNrWyFCbZqOJYP1QvHdbvE0csBGDrW7YT9vFJmGUoq3aIG7RJ+cmlXKHjcNRDlgv4qIG2MhVfTEmsB9Lsc2mH/BujGPDpo3JSBoABnio5cPXRvE858U4efCS7UnFz9bqKdNi7B+DRj30Ui3KhldHWIuUinkT6S2LZHZsx5SZfiRGtyyercpc74s84g5GlrWMm46cW2OBM9uGjfulxkMNFTLz4O7qlOxL9u1ROv5fc3EcbdHfPaeYgb/5TpaZ7yW0fNIxPJACN8I7eZtAEHCSxklwmwwW4yW9hhKufmu0lH1oY17eVN2TRW5amzpB3o9Gv+C0tPjp0J9GPbwKFd4UTWTj+qL37c8z0wtqvjYLZS0cDUPbg/l5ttIFvIGwx28KqccOZf0KmJnr5wZY/8bAGTYd5CLpwzQNn5AwQauS9afPfcUGq+rjkosh+J2TB1tqD8sfrA+BnnzAnHCnMHKCmfr/bVJrB8v4xXHuTzwgKcSV5Qq+m6om/GPvFe1zOUAtlBN0tEFLst0PxTg2JncW78J+U3I+d463EB6bxNqIRD0SBgOViddx+fqNVReUDyqhZA0Tml3uXiGXxYPQZjak+LNVIYREQcg/YIzFdh5fzGj9lUQZLc0h6vgUtekkIZd4ydh2DHg9mlQPC4jq4PEVvGakmxVyNmP0RDKvrdBylpuGnyxMiQ4IvoDZ+R81lOdvuohwamNg3Md+towSUhZVjYFuRdFDbw1P3qQ0HRmUlnRwtVifJlbFpoQpCBU=');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CAppBar(),
        body: ExampleListView(widgets: examples(context)));
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
            itemBuilder: (context, index) {
              return widgets[index];
            }));
  }
}