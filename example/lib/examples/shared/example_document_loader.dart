// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'dart:io';

import 'package:flutter/material.dart';

import '../../utils/file_util.dart';

/// Example Document Loader
///
/// Handles unified loading of example PDF resources and error display
class ExampleDocumentLoader extends StatelessWidget {
  /// Title
  final String title;

  /// Asset path
  final String assetPath;

  /// Whether to overwrite
  final bool shouldOverwrite;

  /// Builder
  final Widget Function(String documentPath) builder;

  /// Constructor
  const ExampleDocumentLoader({
    super.key,
    required this.title,
    required this.assetPath,
    required this.builder,
    this.shouldOverwrite = false,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<File>(
      future: extractAsset(assetPath, shouldOverwrite: shouldOverwrite),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return _buildLoading(context);
        }
        if (!snapshot.hasData) {
          return _buildError(context, snapshot.error);
        }
        return builder(snapshot.data!.path);
      },
    );
  }

  Widget _buildLoading(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildError(BuildContext context, Object? error) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Failed to load example document${error == null ? '' : ': $error'}',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
