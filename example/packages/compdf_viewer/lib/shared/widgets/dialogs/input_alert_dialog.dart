// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// A dialog widget for collecting text input from the user.
///
/// This dialog presents a text field with optional pre-filled text,
/// hint text, and customizable title styling.
///
/// **Features:**
/// - Auto-focus on text field when opened
/// - Pre-fill existing text for editing
/// - Hint text support
/// - Customizable title text style
/// - Cancel and Confirm actions
///
/// **Return Behavior:**
/// - Confirm callback: Receives the entered text
/// - Confirm without callback: Returns text via Get.back(result: text)
/// - Cancel: Closes dialog without return value
///
/// **Usage:**
/// ```dart
/// // With callbacks
/// showDialog(
///   context: context,
///   builder: (context) => InputAlertDialog(
///     title: 'Enter Name',
///     hintText: 'Your name here',
///     text: 'John Doe', // Pre-filled
///     onConfirm: (text) {
///       print('User entered: $text');
///       Navigator.pop(context);
///     },
///   ),
/// );
///
/// // With Get.back result
/// final result = await Get.dialog<String>(
///   InputAlertDialog(
///     title: 'Enter Bookmark Name',
///     hintText: 'Bookmark name',
///   ),
/// );
/// ```
class InputAlertDialog extends StatefulWidget {
  final String title;

  final String? hintText;

  final ValueChanged<String>? onConfirm;

  final Function? onCancel;

  final TextStyle? titleTextStyle;

  final String? text;

  const InputAlertDialog({
    super.key,
    required this.title,
    this.hintText,
    this.onConfirm,
    this.onCancel,
    this.titleTextStyle,
    this.text,
  });

  @override
  State<InputAlertDialog> createState() => _InputAlertDialogState();
}

class _InputAlertDialogState extends State<InputAlertDialog> {
  final TextEditingController _textEditingController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _textEditingController.text = widget.text ?? '';
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: widget.title.isNotEmpty
          ? Text(widget.title, style: widget.titleTextStyle)
          : null,
      content: TextField(
        focusNode: _focusNode,
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: widget.hintText?.isNotEmpty == true ? widget.hintText : '',
          hintStyle: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (widget.onCancel != null) {
              widget.onCancel?.call();
            } else {
              Get.back();
            }
          },
          child: Text(PdfLocaleKeys.cancel.tr),
        ),
        TextButton(
          onPressed: () {
            if (widget.onConfirm != null) {
              widget.onConfirm?.call(_textEditingController.text);
            } else {
              Get.back(result: _textEditingController.text);
            }
          },
          child: Text(PdfLocaleKeys.confirm.tr),
        ),
      ],
    );
  }
}
