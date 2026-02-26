// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// A reusable confirmation dialog widget with customizable title, content, and actions.
///
/// This dialog presents a confirmation message with optional cancel and confirm buttons,
/// using Material Design AlertDialog styling.
///
/// **Components:**
/// - Title (optional) - Dialog header text
/// - Content (optional) - Main message text
/// - Cancel button (optional) - Shown only if onCancel callback provided
/// - Confirm button (optional) - Shown only if onConfirm callback provided
///
/// **Default Button Labels:**
/// - Cancel: Uses localized "Cancel" text
/// - Confirm: Uses localized "Confirm" text
///
/// **Usage:**
/// ```dart
/// showDialog(
///   context: context,
///   builder: (context) => ConfirmAlertDialog(
///     title: 'Delete Item',
///     content: 'Are you sure you want to delete this item?',
///     onCancel: () => Navigator.pop(context),
///     onConfirm: () {
///       deleteItem();
///       Navigator.pop(context);
///     },
///   ),
/// );
/// ```
class ConfirmAlertDialog extends StatelessWidget {
  final String title;

  final String content;

  final String? confirmText;
  final String? cancelText;

  final Function? onConfirm;

  final Function? onCancel;

  const ConfirmAlertDialog({
    super.key,
    required this.title,
    required this.content,
    this.confirmText,
    this.cancelText,
    this.onConfirm,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: title.isNotEmpty ? Text(title) : null,
      content: content.isNotEmpty ? Text(content) : null,
      actions: [
        if (onCancel != null) ...{
          TextButton(
            onPressed: () {
              onCancel?.call();
            },
            child: Text(cancelText ?? PdfLocaleKeys.cancel.tr),
          ),
        },
        if (onConfirm != null) ...{
          TextButton(
            onPressed: () {
              onConfirm?.call();
            },
            child: Text(confirmText ?? PdfLocaleKeys.confirm.tr),
          ),
        },
      ],
    );
  }
}
