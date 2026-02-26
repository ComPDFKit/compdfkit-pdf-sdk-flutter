// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:compdf_viewer/l10n/pdf_locale_keys.dart';

/// A page for setting or removing PDF document password encryption.
///
/// This page provides a user interface for configuring password protection
/// on PDF documents with validation for password matching.
///
/// **Features:**
/// - Toggle password protection on/off
/// - Password and confirmation input fields
/// - Real-time validation with error messages
/// - Returns the password or empty string on confirmation
///
/// **Validation Rules:**
/// - Password cannot be empty when enabled
/// - Confirmation password cannot be empty
/// - Password and confirmation must match
///
/// **Return Values:**
/// - Non-empty string: The password to set
/// - Empty string (''): Remove password protection
/// - null: User cancelled (back navigation)
///
/// **Usage:**
/// ```dart
/// final password = await Get.to<String>(
///   () => PdfEncryptPage(title: 'Set Password'),
/// );
/// if (password != null) {
///   // Apply password to document
/// }
/// ```
class PdfEncryptPage extends StatefulWidget {
  final String title;

  const PdfEncryptPage({super.key, required this.title});

  @override
  State<PdfEncryptPage> createState() => _PdfEncryptPageState();
}

class _PdfEncryptPageState extends State<PdfEncryptPage> {
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _enablePassword = true;
  String _errorTips = '';

  @override
  void initState() {
    super.initState();
    _passwordController.addListener(_clearError);
    _confirmPasswordController.addListener(_clearError);
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _clearError() {
    if (_errorTips.isNotEmpty) {
      setState(() => _errorTips = '');
    }
  }

  void _handleDone() {
    if (!_enablePassword) {
      Get.back(result: '');
      return;
    }
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty) {
      setState(() => _errorTips = PdfLocaleKeys.setPasswordEmpty.tr);
      return;
    }
    if (confirmPassword.isEmpty) {
      setState(() => _errorTips = PdfLocaleKeys.setVerifyPasswordEmpty.tr);
      return;
    }
    if (password != confirmPassword) {
      setState(() => _errorTips = PdfLocaleKeys.setPasswordDiff.tr);
      return;
    }
    Get.back(result: password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: Text(widget.title),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              onPressed: _handleDone,
              child: Text(
                PdfLocaleKeys.confirm.tr,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEnablePasswordRow(),
            const Divider(height: 0.5, thickness: 0.5, color: Colors.black12),
            if (_enablePassword) _buildSetPasswordWidget(),
          ],
        ),
      ),
    );
  }

  Widget _buildEnablePasswordRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(PdfLocaleKeys.passwordMode.tr),
        Switch(
          value: _enablePassword,
          onChanged: (value) {
            setState(() {
              _enablePassword = value;
              _errorTips = '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildSetPasswordWidget() {
    return Column(
      children: [
        _buildSetPasswordRow(
          PdfLocaleKeys.password.tr,
          PdfLocaleKeys.pleaseEnterPassword.tr,
          _passwordController,
        ),
        const Divider(height: 0.5, thickness: 0.5, color: Colors.black12),
        _buildSetPasswordRow(
          PdfLocaleKeys.confirm.tr,
          PdfLocaleKeys.pleaseEnterPasswordAgain.tr,
          _confirmPasswordController,
        ),
        const Divider(height: 0.5, thickness: 0.5, color: Colors.black12),
        if (_errorTips.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              _errorTips,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
      ],
    );
  }

  Widget _buildSetPasswordRow(
      String title, String hint, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(title)),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium
                    ?.copyWith(color: Colors.black38),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 8,
                ),
              ),
              obscureText: true,
            ),
          ),
        ],
      ),
    );
  }
}
