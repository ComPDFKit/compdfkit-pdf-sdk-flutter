// Copyright © 2014-2026 PDF Technologies, Inc. All Rights Reserved.
//
// THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
// AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE ComPDFKit LICENSE AGREEMENT.
// UNAUTHORIZED REPRODUCTION AND DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
// This notice may not be removed from this file.

import 'package:compdfkit_flutter/signature/cpdf_certificate.dart';
import 'package:compdfkit_flutter/signature/cpdf_digital_signature.dart';
import 'package:compdfkit_flutter/signature/cpdf_signature_ltv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'digital_signature_flow.dart';

part 'digital_signature_sheet.dart';
part 'digital_signature_certificate_dialogs.dart';
part 'digital_signature_info_dialog.dart';
part 'digital_signature_common.dart';

const _primary = Color(0xFF1460F3);
const _background = Color(0xFFF6F8FB);
const _border = Color(0xFFE1E6EE);
const _muted = Color(0xFF6B7280);
const _text = Color(0xFF1A1A1A);
const _error = Color(0xFFD92D20);
