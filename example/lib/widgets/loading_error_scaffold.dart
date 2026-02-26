// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// Reusable loading and error state scaffolding components.
///
/// Provide unified loading and error interface display to reduce duplicate code.
class LoadingErrorScaffold extends StatelessWidget {
  /// Page title
  final String title;

  /// Loading content widget (optional)
  final Widget? loadingWidget;

  /// Error message text
  final String? errorText;

  const LoadingErrorScaffold({
    super.key,
    required this.title,
    this.loadingWidget,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: errorText != null
            ? Text(
                errorText!,
                textAlign: TextAlign.center,
              )
            : (loadingWidget ?? const CircularProgressIndicator()),
      ),
    );
  }
}
