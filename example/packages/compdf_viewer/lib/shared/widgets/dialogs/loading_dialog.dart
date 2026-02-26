// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';

/// A simple loading dialog with a centered circular progress indicator.
///
/// This dialog displays a transparent background with a compact circular
/// progress indicator, typically used for short async operations.
///
/// **Visual Style:**
/// - 56x56px size
/// - Transparent background
/// - No elevation shadow
/// - 3px stroke width for progress indicator
///
/// **Usage:**
/// ```dart
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (context) => LoadingDialog(),
/// );
/// ```
class LoadingDialog extends StatelessWidget {
  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        width: 56,
        height: 56,
        child: const Center(
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
      ),
    );
  }
}
